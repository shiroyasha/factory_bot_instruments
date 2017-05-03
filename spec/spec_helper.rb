require "bundler/setup"
require "factory_girl_instruments"

require "active_record"

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => "factory_girl_instruments_test.db"
)

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'users'
    create_table :users do |table|
      table.column :name,     :string
      table.column :username, :string
    end
  end

  unless ActiveRecord::Base.connection.tables.include? 'articles'
    create_table :articles do |table|
      table.column :title,   :string
      table.column :content, :string
      table.column :user_id, :string
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
