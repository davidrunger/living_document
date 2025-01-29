# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LivingDocument::CodeEvaluator do
  subject(:code_evaluator) do
    LivingDocument::CodeEvaluator.new(code:)
  end

  describe '#evaluated_code' do
    subject(:evaluated_code) { code_evaluator.evaluated_code }

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

      it 'does not modify the original code string/object' do
        expect(code).to include('###')
      end
    end

    context 'when there are multiple code segments marked for evaluation' do
      let(:code) do
        <<~RUBY
          1 + 2
          ###

          4 / 0
          ###

          99 - 66
          ###
        RUBY
      end

      let(:expected_evaluated_code) do
        <<~RUBY
          1 + 2
          # => 3

          4 / 0
          # => raises ZeroDivisionError (divided by 0)

          99 - 66
          # => 33
        RUBY
      end

      it 'evaluates them all' do
        expect(evaluated_code).to eq(expected_evaluated_code)
      end
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

    context 'when one of the evaluated statements is a string w/ a double quote' do
      let(:code) do
        <<~RUBY
          '"a string with double quotes"' ###
        RUBY
      end

      let(:expected_evaluated_code) do
        <<~RUBY
          '"a string with double quotes"' # => '"a string with double quotes"'
        RUBY
      end

      specify { expect(evaluated_code).to eq(expected_evaluated_code) }
    end

    context 'when one of the evaluated statements is a string w/ an escaped double quote' do
      let(:code) do
        <<~RUBY
          JSON({a: 1}) ###
        RUBY
      end

      let(:expected_evaluated_code) do
        <<~RUBY
          JSON({a: 1}) # => '{"a":1}'
        RUBY
      end

      specify { expect(evaluated_code).to eq(expected_evaluated_code) }
    end

    context 'when the code raises an error' do
      let(:code) do
        <<~RUBY
          3 / 0
          ###
        RUBY
      end

      let(:expected_evaluated_code) do
        <<~RUBY
          3 / 0
          # => raises ZeroDivisionError (divided by 0)
        RUBY
      end

      specify { expect(evaluated_code).to eq(expected_evaluated_code) }
    end

    context 'when the `code` prints something via `puts`' do
      let(:code) do
        <<~RUBY
          puts('Hello testing world!')
          ###
        RUBY
      end

      let(:expected_evaluated_code) do
        <<~RUBY
          puts('Hello testing world!')
          # => prints "Hello testing world!"
        RUBY
      end

      specify { expect(evaluated_code).to eq(expected_evaluated_code) }
    end

    context 'when the `code` prints multiple things via `puts`' do
      let(:code) do
        <<~RUBY
          puts('Hello testing world!')
          puts('Hello again!')
          ###
        RUBY
      end

      let(:expected_evaluated_code) do
        <<~RUBY
          puts('Hello testing world!')
          puts('Hello again!')
          # => prints "Hello testing world!", "Hello again!"
        RUBY
      end

      specify { expect(evaluated_code).to eq(expected_evaluated_code) }
    end

    context 'when the `code` prints something via `puts` from within an object' do
      let(:code) do
        <<~RUBY
          class Dog
            def bark
              puts('Woof!')
            end
          end
          Dog.new.bark
          ###
        RUBY
      end

      let(:expected_evaluated_code) do
        <<~RUBY
          class Dog
            def bark
              puts('Woof!')
            end
          end
          Dog.new.bark
          # => prints "Woof!"
        RUBY
      end

      specify { expect(evaluated_code).to eq(expected_evaluated_code) }
    end
  end
end
