ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'capybara/rspec'
require 'capybara/rails'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.include FeatureMacros, type: :feature
  config.include FlyoverComments::Engine.routes.url_helpers
  config.include Devise::TestHelpers, type: :controller
end
