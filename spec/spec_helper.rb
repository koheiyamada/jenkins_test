require 'rubygems'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'sunspot_test/rspec'
require 'sunspot/rails/spec_helper'

Dir[Rails.root.join("spec/support/*.rb")].each { |f| require f }

Rspec.configure do |config|
	#config.filter_run :focus => true
	#config.run_all_when_everything_filtered = true
end