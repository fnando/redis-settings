# Redis::Settings

[![Travis-CI](https://travis-ci.org/fnando/redis-settings.png)](https://travis-ci.org/fnando/redis-settings)
[![CodeClimate](https://codeclimate.com/github/fnando/redis-settings.png)](https://codeclimate.com/github/fnando/redis-settings)
[![Gem](https://img.shields.io/gem/v/redis-settings.svg)](https://rubygems.org/gems/redis-settings)
[![Gem](https://img.shields.io/gem/dt/redis-settings.svg)](https://rubygems.org/gems/redis-settings)

Store application and user settings on Redis. Comes with ActiveRecord support.

## Installation

    gem install redis-settings

## Usage

```ruby
require "redis/settings"

# Reuse an existing Redis connection.
Redis::Settings.configure do |config|
config.connection = Redis.new(:host => "localhost", :port => 6379)
end

# Create settings namespaced to app
settings = Redis::Settings.new("app")
settings.namespace
#=> "settings/app"

# Set values
settings[:items_per_page] = 10
settings.set(:items_per_page, 10)

# Get values
settings[:items_per_page]
settings.get(:items_per_page)
settings.get(:items_per_page, 20) #=> return 20 when items_per_page is not defined

# Remove all settings on this namespace
settings.clear

# Retrieve a hash with defined settings
settings.all
```

### ActiveRecord

```ruby
class User < ActiveRecord::Base
end

user = User.first
user.settings[:role] = "admin"
```

**NOTE:** When record is destroyed, all settings are erased.

### Rails

Rails set its own namespace like `settings/#{Rails.env}`.

You can override the root namespace as

```ruby
Redis::Settings.root_namespace = "custom"
```

### JSON adapter

Redis::Settings store all data in JSON format; [oj](https://github.com/ohler55/oj) will be used as the JSON adapter when available, defaulting to Ruby's JSON.

You can set to anything by assigning the `Redis::Settings.json_parser` option.

```ruby
Redis::Settings.json_parser = JSON
```

# Mantainer

- Nando Vieira (http://nandovieira.com)

# License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
