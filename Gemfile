# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in living_document.gemspec
gemspec

group :development, :test do
  gem 'amazing_print'
  gem 'pry-byebug'
  gem 'rake'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rake', require: false
  gem 'runger_style', github: 'davidrunger/runger_style', require: false
end

group :development do
  gem 'release_assistant', require: false, github: 'davidrunger/release_assistant'
end

group :test do
  gem 'guard-espect', require: false, github: 'davidrunger/guard-espect'
  gem 'rspec'
end
