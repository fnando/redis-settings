require "bundler"
Bundler.setup(:default, :development)

require "active_record"
require "redis/settings"
require "redis/namespace"

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|file| require file}

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"

$redis = Redis.new(:host => "localhost", :port => 6379)
Redis::Settings.connection = Redis::Namespace.new("redis-settings", :redis => $redis)

ActiveRecord::Schema.define(:version => 0) do
  create_table :users do |t|
    t.string :login
  end
end

RSpec.configure do |config|
  config.before do
    $redis.keys("redis-settings*").each {|key| $redis.del(key)}
  end
end
