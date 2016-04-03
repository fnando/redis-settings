require "./lib/redis/settings/version"

Gem::Specification.new do |s|
  s.name        = "redis-settings"
  s.version     = Redis::Settings::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nando Vieira"]
  s.email       = ["fnando.vieira@gmail.com"]
  s.homepage    = "http://github.com/fnando/redis-settings"
  s.summary     = %[Store application and user settings on Redis. Comes with ActiveRecord support.]
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "redis"
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest-utils"
  s.add_development_dependency "activerecord"
  s.add_development_dependency "redis-namespace"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry-meta"
end
