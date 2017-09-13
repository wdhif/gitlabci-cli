# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitlabci/controller/version'

Gem::Specification.new do |spec|
  spec.name          = 'gitlabci-cli'
  spec.version       = Gitlabci::Controller::VERSION
  spec.authors       = ['Wassim DHIF']
  spec.email         = ['wassimdhif@gmail.com']

  spec.summary       = 'Control your GitlabCI workflow from your terminal'
  spec.description   = 'Control your GitlabCI workflow from your terminal'
  spec.homepage      = 'http://github.com/wdhif/gitlabci-cli'

  spec.files         = []
  spec.executables   = 'gitlabci-cli'
  spec.require_paths = ['lib']

  spec.add_dependency 'thor'
  spec.add_dependency 'rest-client'
  spec.add_dependency 'json'
  spec.add_dependency 'json_pure'
  spec.add_dependency 'terminal-table'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rubocop'
end
