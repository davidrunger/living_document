#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require_relative '../lib/living_document.rb'

# perform automatic server reloading if and only if doing active gem development
probably_in_gem_directory = ENV['PWD'].end_with?('/living_document')
if probably_in_gem_directory
  require 'sinatra/reloader'
  also_reload 'lib/living_document/code_evaluator.rb'
end

get '/' do
  erb '' # just render the layout
end

post '/run_code' do
  payload = JSON.parse(request.body.read)
  frontmatter = payload['frontmatter']
  code = payload['code']

  evaluated_code =
    LivingDocument::DocumentEvaluator.new(
      frontmatter: frontmatter,
      document: code,
    ).evaluated_document

  content_type :json
  { evaluated_code: evaluated_code }.to_json
end
