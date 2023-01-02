# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LivingDocument::DocumentEvaluator do
  subject(:document_evaluator) do
    LivingDocument::DocumentEvaluator.new(document:, frontmatter:)
  end

  describe '#evaluated_document' do
    subject(:evaluated_document) { document_evaluator.evaluated_document }

    context 'when the `frontmatter` is an empty string' do
      let(:frontmatter) { '' }

      context 'when the `document` is just Ruby code' do
        let(:document) do
          <<~RUBY
            2 ** 5
            ###
          RUBY
        end

        let(:expected_evaluated_document) do
          <<~RUBY
            2 ** 5
            # => 32
          RUBY
        end

        specify { expect(evaluated_document).to eq(expected_evaluated_document) }

        it 'does not modify the original document string/object' do
          expect(document).to include('###')
        end
      end

      context 'when the `document` is markdown containing Ruby codeblocks' do
        let(:document) do
          <<~MARKDOWN
            This is how you do addition in Ruby:

            ```rb
            2 + 3
            ###
            ```

            This is how you do exponentiation in Ruby:

            ```ruby
            2 ** 4
            ###
            ```
          MARKDOWN
        end

        let(:expected_evaluated_document) do
          <<~MARKDOWN
            This is how you do addition in Ruby:

            ```rb
            2 + 3
            # => 5
            ```

            This is how you do exponentiation in Ruby:

            ```ruby
            2 ** 4
            # => 16
            ```
          MARKDOWN
        end

        specify { expect(evaluated_document).to eq(expected_evaluated_document) }

        it 'does not modify the original document string/object' do
          expect(document).to include('###')
        end
      end
    end
  end
end
