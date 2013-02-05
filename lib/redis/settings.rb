require "redis"

begin
  require "yajl/json_gem"
rescue LoadError
  require "json"
end

class Redis
  class Settings
    require "redis/settings/active_record" if defined?(ActiveRecord)
    require "redis/settings/railtie" if defined?(Rails) && Rails.version >= "3.0.0"

    class NewRecordError < StandardError
      def message; "You can't access settings on new records"; end
    end

    class << self
      attr_accessor :connection
      attr_accessor :root_namespace
    end

    # Set the root namespace to "settings" by default.
    self.root_namespace = "settings"

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

    # Return instance's namespace concatenated with Redis::Settings.root_namespace.
    #
    #   s = Redis::Settings.new("app")
    #   s.namespace
    #   #=> "settings/app"
    #
    def namespace
      "#{self.class.root_namespace}/#{@namespace}"
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

      value.nil? ? default : value
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

    # Delete the specified option. Just a shortcut for <tt>settings.set(:name, nil)</tt>.
    #
    def remove(name)
      set(name, nil)
    end

    alias_method :delete, :remove

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
    alias_method :fetch, :get

    private
    def redis # :nodoc:
      self.class.connection
    end
  end
end
