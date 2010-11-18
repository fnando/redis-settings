require "active_record"
require "redis/settings"

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|file| require file}

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"
Redis::Settings.connection = Redis.new(:host => "localhost", :port => 6379)

ActiveRecord::Schema.define(:version => 0) do
  create_table :users do |t|
    t.string :login
  end
end
