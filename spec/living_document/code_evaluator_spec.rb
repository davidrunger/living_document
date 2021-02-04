# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LivingDocument::CodeEvaluator do
  subject(:code_evaluator) do
    LivingDocument::CodeEvaluator.new(
      code: code,
      frontmatter: frontmatter,
    )
  end

  describe '#evaluated_code' do
    subject(:evaluated_code) { code_evaluator.evaluated_code }

    context 'when the `frontmatter` is an empty string' do
      let(:frontmatter) { '' }

      context 'when the `code` has a `###` evaluation marker' do
        let(:code) do
          <<~RUBY
            a = 1
            b = 2
            a + b
            ###
          RUBY
        end

        let(:expected_evaluated_code) do
          <<~RUBY
            a = 1
            b = 2
            a + b
            # => 3
          RUBY
        end

        specify { expect(evaluated_code).to eq(expected_evaluated_code) }
      end

      context 'when the `code` has a `# =>` evaluation marker' do
        let(:code) do
          <<~RUBY
            a = 2
            b = 3
            a + b
            # => 3
          RUBY
        end

        let(:expected_evaluated_code) do
          <<~RUBY
            a = 2
            b = 3
            a + b
            # => 5
          RUBY
        end

        specify { expect(evaluated_code).to eq(expected_evaluated_code) }
      end
    end
  end
end
