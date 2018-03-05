require "active_record"

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => "/tmp/factory_bot_instruments_test.db"
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

  unless ActiveRecord::Base.connection.tables.include? 'comments'
    create_table :comments do |table|
      table.column :content,    :string
      table.column :user_id,    :string
      table.column :article_id, :string
    end
  end
end

Dir["spec/models/*.rb"].each { |f| require "./#{f}" }
Dir["spec/factories/*.rb"].each { |f| require "./#{f}" }
