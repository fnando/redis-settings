class Redis
  class Settings
    class Railtie < Rails::Railtie
      initializer :redis_settings do
        Settings.root_namespace = "settings/#{Rails.env}"
      end
    end
  end
end
