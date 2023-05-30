# frozen_string_literal: true

require 'active_support/core_ext/string/filters' # for `#squish`
require 'memo_wise'
require 'stringio'

module LivingDocument ; end

Dir["#{File.dirname(__FILE__)}/living_document/**/*.rb"].each { |file| require file }
