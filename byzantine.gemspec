# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'byzantine/version'

Gem::Specification.new do |spec|
  spec.name          = 'byzantine'
  spec.version       = Byzantine::VERSION
  spec.authors       = ['Maciej Gawel', 'Bartosz Zurkowski']
  spec.email         = ['m.gawel@hotmail.com', 'zurkowski.bartosz@gmail.com']

  spec.summary       = 'Key-value store based on Paxos Byzantine protocol'
  spec.description   = 'Key-value store based on Paxos Byzantine protocol'
  spec.homepage      = 'https://github.com/iosr2016/paxos-byzantine'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rubocop', '~> 0.44.1'
  spec.add_development_dependency 'overcommit', '~> 0.37.0'
  spec.add_development_dependency 'simplecov'
end
