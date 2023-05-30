# frozen_string_literal: true

require_relative 'lib/living_document/version'

Gem::Specification.new do |spec|
  spec.name          = 'living_document'
  spec.version       = LivingDocument::VERSION
  spec.authors       = ['David Runger']
  spec.email         = ['davidjrunger@gmail.com']

  spec.summary       = 'Evaluate Ruby code live while editing a file!'
  spec.description   = 'Evaluate Ruby code live while editing a file!'
  spec.homepage      = 'https://github.com/davidrunger/living_document'
  spec.license       = 'MIT'

  ruby_version = File.read('.ruby-version').rstrip
  spec.required_ruby_version = Gem::Requirement.new(">= #{ruby_version}")

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/davidrunger/living_document'
  spec.metadata['changelog_uri'] = 'https://github.com/davidrunger/living_document/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files =
    Dir.chdir(File.expand_path(__dir__)) do
      `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
    end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.add_runtime_dependency('activesupport', '>= 6', '< 8')
  spec.add_runtime_dependency('listen', '~> 3.2')
  spec.add_runtime_dependency('memo_wise', '>= 1.7', '< 2')
  spec.add_runtime_dependency('redcarpet', '~> 3.5')
  spec.add_runtime_dependency('sinatra', '>= 2.1', '< 4.0')
end
