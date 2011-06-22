# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "redis/settings/version"

Gem::Specification.new do |s|
  s.name        = "redis-settings"
  s.version     = Redis::Settings::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nando Vieira"]
  s.email       = ["fnando.vieira@gmail.com"]
  s.homepage    = ""
  s.summary     = %[Store application and user settings on Redis. Comes with ActiveRecord support.]
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "redis"
  s.add_development_dependency "rake", "~> 0.8.7"
  s.add_development_dependency "rspec", "~> 2.6"
  s.add_development_dependency "ruby-debug19"
  s.add_development_dependency "activerecord"
  s.add_development_dependency "sqlite3-ruby"
end
