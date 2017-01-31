# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thinking_sphinx/capistrano/monit/version'

Gem::Specification.new do |spec|
  spec.name = 'thinking-sphinx-capistrano-monit'
  spec.version = ThinkingSphinx::Capistrano::Monit::VERSION
  spec.authors = ['Michal Mrozek']
  spec.email = ['michalmrozek@wp.pl']
  spec.description = spec.summary = %q{Monit integration with Thinking Sphinx and Capistrano}
  spec.homepage = 'https://github.com/Michsior14/thinking-sphinx-capistrano-monit'
  spec.license = 'MIT'

  spec.add_runtime_dependency 'capistrano', '~> 3.0', '>= 3.0.0'
  spec.add_runtime_dependency 'thinking-sphinx', '~> 3.3.0'

  spec.required_ruby_version = '>= 1.9.3'
  spec.files = `git ls-files`.split($/)
  spec.require_paths = ['lib']
end
