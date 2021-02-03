# frozen_string_literal: true

require 'active_support/core_ext/string/filters' # for `#squish`

module LivingDocument ; end

Dir["#{File.dirname(__FILE__)}/living_document/**/*.rb"].sort.each { |file| require file }
