# frozen_string_literal: true

class LivingDocument::CodeEvaluator
  prepend MemoWise

  def initialize(code:)
    @code = code.dup

    @known_erroring_segment_indexes = []
    @random_seed = rand(1_000_000_000)

    $printed_objects_last_run = []
  end

  def evaluated_code
    set_up_capturing_stdout

    printed_code_segments.each_with_index do |printed_code_segment, index|
      $printed_objects = []

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

      if newly_printed_objects.any?
        result = %(prints #{newly_printed_objects.map(&:inspect).join(', ')})
      elsif result.include?('\"')
        result = "'#{result.gsub('\"', '"')[1...-1]}'"
      end
      remember_printed_objects

      swap_in_evaluated_code(printed_code_segment, result)
    end

    restore_original_stdout

    @code
  end

  private

  def set_up_capturing_stdout
    @original_stdout = $stdout
    $stdout = LivingDocument::CapturingStringIO.new
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

  def newly_printed_objects
    $printed_objects - $printed_objects_last_run
  end

  memo_wise \
  def printed_code_segments
    @code.scan(/(?:(?!###|# =>).)*(?:###|# =>)[^\n]*\s*/mi)
  end

  def printed_code_segments_to_eval(current_index)
    printed_code_segments.values_at(*indexes_to_eval(current_index))
  end

  def remember_printed_objects
    $printed_objects_last_run = $printed_objects
  end

  def swap_in_evaluated_code(printed_code_segment, result)
    @code[printed_code_segment] = printed_code_segment.sub(/(?:# =>|###)[^\n]*$/, "# => #{result}")
  end
end
