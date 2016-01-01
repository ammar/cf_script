if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter "/test/"
  end
end

gem 'minitest'

require 'minitest/autorun'
require "minitest/focus"
require 'minitest/pride'

if ENV['REPORTER']
  require 'minitest/reporters'

  case ENV['REPORTER']
  when 'spec'
    Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
  when 'progress'
    Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new
  when 'time'
    Minitest::Reporters.use! Minitest::Reporters::MeanTimeReporter.new
  else
    Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new
  end
end

require 'pry'
require_relative './support/helpers'
require_relative './support/shared_examples'

require File.expand_path("../../lib/cf_script", __FILE__)
