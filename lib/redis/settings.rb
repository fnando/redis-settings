require "redis"

begin
  require "yajl/json_gem"
rescue LoadError
  require "json"
end

class Redis
  class Settings
    require "redis/settings/active_record" if defined?(ActiveRecord)

    class NewRecordError < StandardError
      def message
        "You can't access settings on new records"
      end
    end

    class << self
      attr_accessor :connection
    end

    # Return Redis::Settings.
    #
    #   Redis::Settings.configure do |config|
    #     config.connection = Redis.new(:host => "localhost", :port => 6379)
    #   end
    #
    def self.configure(&block)
      yield self
    end

    # Initialize a new object that will be wrapped into the specified
    # namespace.
    #
    #   s = Redis::Settings.new("app")
    #
    def initialize(namespace)
      @namespace = namespace
    end

    # Returned namespace with <tt>settings</tt> as its root.
    #
    #   s = Redis::Settings.new("app")
    #   s.namespace
    #   #=> "settings/app"
    #
    def namespace
      "settings/#{@namespace}"
    end

    # Retrieve setting by its name. When nil, return the default value.
    #
    #   s = Redis::Settings.new("app")
    #   s.get(:items_per_page)
    #   s.get(:items_per_page, 10)
    #
    def get(name, default = nil)
      value = redis.hget(namespace, name)

      if value
        payload = JSON.parse(value)
        value = payload["data"]
      end

      value || default
    end

    # Define a value for the specified setting.
    #
    #   s = Redis::Settings.new("app")
    #   s.set(:items_per_page, 10)
    #
    def set(name, value)
      if value.nil?
        redis.hdel(namespace, name)
      else
        redis.hset(namespace, name, {:data => value}.to_json)
      end
    end

    # Remove all settings from the current namespace
    def clear
      redis.del(namespace)
    end

    # Return a hash with all settings
    def all
      Hash[redis.hgetall(namespace).collect {|k, v| [k.to_sym, JSON.parse(v)["data"]]}]
    end

    alias_method :[]=, :set
    alias_method :[], :get

    private
    def redis # :nodoc:
      self.class.connection
    end
  end
end
