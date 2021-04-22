#!/usr/bin/env ruby
# frozen_string_literal: true

require 'redcarpet'
require 'sinatra'
require_relative '../lib/living_document.rb'

# perform automatic server reloading if and only if doing active gem development
probably_in_gem_directory = ENV['PWD'].end_with?('/living_document')
if probably_in_gem_directory
  require 'sinatra/reloader'
  also_reload 'lib/living_document/code_evaluator.rb'
  also_reload 'lib/living_document/document_evaluator.rb'
end

get '/' do
  erb '' # just render the layout
end

post '/run_code' do
  payload = JSON.parse(request.body.read)
  frontmatter = payload['frontmatter']
  code = payload['code']

  document_evaluator =
    LivingDocument::DocumentEvaluator.new(frontmatter: frontmatter, document: code)
  evaluated_document = document_evaluator.evaluated_document
  rendered_markdown =
    if document_evaluator.markdown?
      Redcarpet::Markdown.new(
        Redcarpet::Render::HTML,
        fenced_code_blocks: true,
      ).render(evaluated_document)
    else
      ''
    end

  content_type :json
  { evaluated_code: evaluated_document, rendered_markdown: rendered_markdown }.to_json
end
