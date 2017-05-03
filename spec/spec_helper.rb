require "bundler/setup"
require "factory_girl_instruments"

require_relative "db_structure"
require_relative "io_helper"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
