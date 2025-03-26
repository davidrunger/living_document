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
    save_original_stdout

    Timecop.freeze do
      printed_code_segments.each_with_index do |printed_code_segment, index|
        $printed_output = ''
        set_up_capturing_stdout

        result =
          begin
            # We need to namespace any constants that would otherwise leak and persist globally.
            new_namespace.
              instance_eval(code_to_eval(index)).
              inspect.
              squish.
              then do |evaluated_result|
                if newly_printed_output.present?
                  result_for_printed_output
                else
                  formatted_evaluated_result(evaluated_result)
                end
              end
          rescue => error
            @known_erroring_segment_indexes << index

            "raises #{error.class} (#{error.message})"
          end

        remember_printed_output

        swap_in_evaluated_code(printed_code_segment, result)
      end
    end

    @code
  ensure
    restore_original_stdout
  end

  private

  def formatted_evaluated_result(evaluated_result)
    if evaluated_result.include?('\"') && !evaluated_result.include?("'")
      "'#{evaluated_result.gsub('\"', '"')[1...-1]}'"
    else
      evaluated_result
    end
  end

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

  def save_original_stdout
    @original_stdout = $stdout
  end

  def set_up_capturing_stdout
    $stdout = StringIO.new
  end

  def restore_original_stdout
    if @original_stdout.present?
      $stdout = @original_stdout
    end
  end

  def code_segments_to_eval(current_index)
    printed_code_segments.values_at(*indexes_to_eval(current_index))
  end

  def code_to_eval(current_index)
    code_segments_to_eval(current_index).join('')
  end

  def indexes_to_eval(current_index)
    (0..current_index).to_a.reject { @known_erroring_segment_indexes.include?(it) }
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

  def remember_printed_output
    $printed_output_last_run = $printed_output
  end

  def swap_in_evaluated_code(printed_code_segment, result)
    @code[printed_code_segment] = printed_code_segment.sub(/(?:# =>|###)[^\n]*$/, "# => #{result}")
  end
end
