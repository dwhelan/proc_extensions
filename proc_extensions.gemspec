# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'proc_extensions/version'

Gem::Specification.new do |gem|
  gem.name          = 'proc_extensions'
  gem.version       = ProcExtensions::VERSION
  gem.authors       = ['Declan Whelan']
  gem.email         = ['dwhelan@leanintuit.com']

  gem.summary       = 'Extensions to the Proc class to support source extraction and comparison.'
  gem.description   = 'Extensions to the Proc class to support source extraction and comparison.'
  gem.homepage      = 'https://github.com/dwhelan/proc_extensions'
  gem.license       = 'MIT'

  gem.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/}) }
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'sourcify', '~> 0.5'

  gem.add_development_dependency 'bundler',     '~>  1.10'
  gem.add_development_dependency 'coveralls',   '~>  0.7'
  gem.add_development_dependency 'guard',       '~>  2.13'
  gem.add_development_dependency 'guard-rspec', '~>  4.6'
  gem.add_development_dependency 'pry-byebug',  '~>  3.3'
  gem.add_development_dependency 'rake',        '~> 10.0'
  gem.add_development_dependency 'rspec',       '~>  3.0'
  gem.add_development_dependency 'rspec-its',   '~>  1.1'
  gem.add_development_dependency 'rubocop',     '~>  0.30'
  gem.add_development_dependency 'simplecov',   '~>  0.9'
end
