$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rspec/its'
require 'simplecov'
require 'coveralls'
require 'pry-byebug'


SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
]
SimpleCov.start

Coveralls.wear! if Coveralls.will_run?

require 'proc_extensions'

Dir[File.dirname(__FILE__) + '/shared/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.color = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
