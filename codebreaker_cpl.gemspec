# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'codebreaker_cpl/version'

Gem::Specification.new do |spec|
  spec.name          = 'codebreaker_cpl'
  spec.version       = CodebreakerCpl::VERSION
  spec.authors       = ['CPL']
  spec.email         = ['cpl.km.ua@gmail.com']

  spec.summary       = 'CodebreakerCpl'
  spec.description   = 'Logic game'
  spec.homepage      = 'https://github.com/Turzhanskyi/codebreaker_cpl'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '2.1.4'
  spec.add_development_dependency 'fasterer', '0.8.3'
  spec.add_development_dependency 'i18n', '1.8.3'
  spec.add_development_dependency 'pry', '0.13.1'
  spec.add_development_dependency 'rake', '13.0.1'
  spec.add_development_dependency 'rspec', '3.9.0'
  spec.add_development_dependency 'rspec_junit_formatter', '0.4.1'
  spec.add_development_dependency 'rubocop', '0.86.0'
  spec.add_development_dependency 'rubocop-rspec', '1.41.0'
  spec.add_development_dependency 'simplecov', '0.18.5'
end
