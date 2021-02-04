# frozen_string_literal: true

class LivingDocument::DocumentEvaluator
  def initialize(document:, frontmatter: nil)
    @document = document.dup
    @frontmatter = frontmatter
  end

  def evaluated_document
    if markdown?
      markdown_codeblocks.each do |markdown_codeblock|
        opening, *ruby_code_lines, closing = markdown_codeblock.split("\n")
        ruby_code = ruby_code_lines.join("\n")
        evaluated_ruby_code =
          LivingDocument::CodeEvaluator.new(
            code: ruby_code,
            frontmatter: @frontmatter,
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
        frontmatter: @frontmatter,
      ).evaluated_code
    end
  end

  private

  def markdown?
    !markdown_codeblocks.empty?
  end

  def markdown_codeblocks
    @document.scan(/```(?:ruby|rb)\n(?:(?!```\n).)*```/mi)
  end
end
