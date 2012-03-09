# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'dtime/version'

Gem::Specification.new do |s|
  s.name          = "dtime"
  s.version       = Dtime::VERSION
  s.authors       = ["David Haslem"]
  s.email         = ["therabidbanana@gmail.com"]
  s.homepage      = "https://github.com/therabidbanana/dtime_gem"
  s.summary       = "Gem for connecting to the hateoas dtime api"
  s.description   = "Gem for connecting to the hateoas dtime api"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_dependency 'hashie', '~> 1.2.0'
  s.add_dependency 'faraday', '~> 0.7.4'
  s.add_dependency 'multi_json', '~> 1.0.3'
  s.add_dependency 'oauth2', '~> 0.5.0'

  s.add_development_dependency 'rspec', '~> 2.8.0'
  s.add_development_dependency 'commander'
  s.add_development_dependency 'yajl-ruby', '~> 0.8.2'
  s.add_development_dependency 'bundler', '~> 1.0.0'
  s.add_development_dependency 'simplecov', '~> 0.4'
  s.add_development_dependency 'webmock', '~> 1.7.6'
end
