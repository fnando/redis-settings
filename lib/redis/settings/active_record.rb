class Redis
  class Settings
    module ActiveRecord
      def self.included(base)
        base.class_eval do
          include InstanceMethods
          after_destroy :clear_settings
        end
      end

      module InstanceMethods
        def settings
          raise Redis::Settings::NewRecordError if new_record?
          @settings ||= Settings.new("#{self.class.name.underscore}/#{id}")
        end

        def clear_settings
          settings.clear unless new_record?
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Redis::Settings::ActiveRecord
