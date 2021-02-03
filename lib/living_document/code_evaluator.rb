# frozen_string_literal: true

class LivingDocument::CodeEvaluator
  def initialize(code:, frontmatter: nil)
    @frontmatter = frontmatter
    @code = code
  end

  def evaluated_code
    printed_code = @code.dup
    printed_code_segments = printed_code.scan(/(?:(?!\n))(?:(?!###|# =>).)*(?:# =>|###)[^\n]*\s*/mi)

    known_erroring_segment_indexes = []
    random_seed = rand(1_000_000_000)
    printed_code_segments.each_with_index do |printed_code_segment, index|
      indexes_to_eval =
        (0..index).to_a.reject { |idx| known_erroring_segment_indexes.include?(idx) }
      groups_to_eval = [@frontmatter] + printed_code_segments.values_at(*indexes_to_eval)

      result = ':NONE:'
      begin
        code_to_eval = groups_to_eval.join('')
        # we need to namespace any constants that would otherwise persist between "save sessions"
        namespace = Module.new
        namespace.instance_eval { srand(random_seed) }
        $printed_objects_last_run ||= []
        $printed_objects = []
        result = namespace.instance_eval(code_to_eval).inspect.squish
        # result = eval(code_to_eval).inspect.squish
        newly_printed_objects = $printed_objects - $printed_objects_last_run
        if newly_printed_objects.any?
          result = %(prints "#{newly_printed_objects.first}")
        end
        $printed_objects_last_run = $printed_objects
      rescue => error
        # Comment these lines back in for debugging:
        # puts("ERROR: #{error.class}:#{error.message}")
        # puts(error.backtrace)
        result = "raises #{error.class}"
        known_erroring_segment_indexes << index
      end

      printed_code[printed_code_segment] =
        printed_code_segment.sub(/(?:# =>|###)[^\n]*$/, "# => #{result}")
    end

    printed_code
  end
end
