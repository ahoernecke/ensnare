$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ensnare/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ensnare"
  s.version     = Ensnare::VERSION
  s.authors     = ["Andy Hoernecke, Scott Behrens"]
  s.email       = [""]
  s.homepage    = "https://github.com/ahoernecke/ensnare"
  s.summary     = "Ensnare."
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.14"
  s.add_dependency "twitter-bootstrap-rails"

  s.add_development_dependency "sqlite3"

end
