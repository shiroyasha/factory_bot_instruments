require "bundler/setup"
require "factory_girl_benchmark"

require "active_record"

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => "factory_girl_benchmark_test.db"
)

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'users'
    create_table :users do |table|
      table.column :name,     :string
      table.column :username, :string
    end
  end
end

Dir["spec/models/*.rb"].each { |f| require "./#{f}" }
Dir["spec/factories/*.rb"].each { |f| require "./#{f}" }

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
