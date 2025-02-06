# frozen_string_literal: true

module LivingDocument
  def self.check_platform!
    if !RUBY_PLATFORM.include?('linux')
      raise('Sorry, but living_document only works on Linux')
    end
  end
end
