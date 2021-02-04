# frozen_string_literal: true

class LivingDocument::CodeEvaluator
  extend Memoist

  def initialize(code:, frontmatter: nil)
    @code = code.dup
    @frontmatter = frontmatter

    @known_erroring_segment_indexes = []
    @random_seed = rand(1_000_000_000)
  end

  def evaluated_code
    printed_code_segments.each_with_index do |printed_code_segment, index|
      initialize_printed_object_globals

      result =
        begin
          # we need to namespace any constants that would otherwise leak and persist globally
          new_namespace.instance_eval(code_to_eval(index)).inspect.squish
        rescue => error
          # Comment these lines back in for debugging:
          # puts("ERROR: #{error.class}:#{error.message}")
          # puts(error.backtrace)
          @known_erroring_segment_indexes << index
          "raises #{error.class}"
        end

      result = %(prints "#{newly_printed_objects.first}") if newly_printed_objects.any?
      remember_printed_objects

      swap_in_evaluated_code(printed_code_segment, result)
    end

    @code
  end

  private

  def code_segments_to_eval(current_index)
    [@frontmatter] + printed_code_segments_to_eval(current_index)
  end

  def code_to_eval(current_index)
    code_segments_to_eval(current_index).join('')
  end

  def indexes_to_eval(current_index)
    (0..current_index).to_a.reject { @known_erroring_segment_indexes.include?(_1) }
  end

  def initialize_printed_object_globals
    $printed_objects_last_run ||= []
    $printed_objects = []
  end

  def new_namespace
    random_seed = @random_seed
    Module.new.tap { _1.instance_eval { srand(random_seed) } }
  end

  def newly_printed_objects
    $printed_objects - $printed_objects_last_run
  end

  memoize \
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
