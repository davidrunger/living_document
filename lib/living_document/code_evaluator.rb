# frozen_string_literal: true

class LivingDocument::CodeEvaluator
  prepend MemoWise

  def initialize(code:)
    @code = code.gsub(/^=begin\b.*?^=end\n/m, '')

    @known_erroring_segment_indexes = []
    @random_seed = rand(1_000_000_000)

    $printed_output_last_run = ''
  end

  def evaluated_code
    Timecop.freeze do
      printed_code_segments.each_with_index do |printed_code_segment, index|
        $printed_output = ''
        set_up_capturing_stdout

        result =
          begin
            # we need to namespace any constants that would otherwise leak and persist globally
            new_namespace.instance_eval(code_to_eval(index)).inspect.squish
          rescue => error
            # Comment these lines back in for debugging:
            # puts("ERROR: #{error.class}:#{error.message}")
            # puts(error.backtrace)
            @known_erroring_segment_indexes << index
            "raises #{error.class} (#{error.message})"
          end

        if newly_printed_output.present?
          result = result_for_printed_output
        elsif result.include?('\"')
          result = "'#{result.gsub('\"', '"')[1...-1]}'"
        end
        remember_printed_objects

        swap_in_evaluated_code(printed_code_segment, result)
      end
    end

    restore_original_stdout

    @code
  end

  private

  def result_for_printed_output
    if newly_printed_output[0..-2].include?("\n")
      %(prints:\n#{commented_output(newly_printed_output)})
    else
      %(prints "#{newly_printed_output.rstrip}")
    end
  end

  def commented_output(printed_output)
    <<~COMMENTED_OUTPUT.rstrip
      =begin
      #{printed_output.delete_suffix("\n")}
      =end
    COMMENTED_OUTPUT
  end

  def set_up_capturing_stdout
    @original_stdout = $stdout
    $stdout = StringIO.new
  end

  def restore_original_stdout
    $stdout = @original_stdout
  end

  def code_segments_to_eval(current_index)
    printed_code_segments_to_eval(current_index)
  end

  def code_to_eval(current_index)
    code_segments_to_eval(current_index).join('')
  end

  def indexes_to_eval(current_index)
    (0..current_index).to_a.reject { @known_erroring_segment_indexes.include?(_1) }
  end

  def new_namespace
    random_seed = @random_seed
    Module.new.tap do |new_module|
      new_module.instance_eval do
        srand(random_seed)
      end
    end
  end

  def newly_printed_output
    $printed_output = $stdout.string.dup
    $printed_output.delete_prefix($printed_output_last_run)
  end

  memo_wise \
  def printed_code_segments
    @code.scan(/(?:(?!###|# =>).)*(?:###|# =>)[^\n]*\s*/mi)
  end

  def printed_code_segments_to_eval(current_index)
    printed_code_segments.values_at(*indexes_to_eval(current_index))
  end

  def remember_printed_objects
    $printed_output_last_run = $printed_output
  end

  def swap_in_evaluated_code(printed_code_segment, result)
    @code[printed_code_segment] = printed_code_segment.sub(/(?:# =>|###)[^\n]*$/, "# => #{result}")
  end
end
