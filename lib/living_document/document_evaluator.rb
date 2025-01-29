# frozen_string_literal: true

class LivingDocument::DocumentEvaluator
  def initialize(document:)
    @document = document.dup
  end

  def evaluated_document
    if markdown?
      markdown_codeblocks.each do |markdown_codeblock|
        opening, *ruby_code_lines, closing = markdown_codeblock.split("\n")
        ruby_code = ruby_code_lines.join("\n")
        evaluated_ruby_code =
          LivingDocument::CodeEvaluator.new(
            code: ruby_code,
          ).evaluated_code
        @document[markdown_codeblock] =
          <<~EVALUATED_CODEBLOCK.rstrip
            #{opening}
            #{evaluated_ruby_code}
            #{closing}
          EVALUATED_CODEBLOCK
      end
      @document
    else
      LivingDocument::CodeEvaluator.new(
        code: @document,
      ).evaluated_code
    end
  end

  def markdown?
    !markdown_codeblocks.empty?
  end

  private

  def markdown_codeblocks
    @document.scan(/```(?:ruby|rb)\n(?:(?!```\n).)*```/mi)
  end
end
