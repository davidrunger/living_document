# frozen_string_literal: true

require 'active_support/all'
require 'memo_wise'
require 'stringio'
require 'timecop'

module LivingDocument ; end

Dir["#{File.dirname(__FILE__)}/living_document/**/*.rb"].each { |file| require file }

LivingDocument.check_platform!
