$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "flyover_comments/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "flyover_comments"
  s.version     = FlyoverComments::VERSION
  s.authors     = ["Ben Roesch"]
  s.email       = ["bcroesch@gmail.com"]
  s.homepage    = "http://github.com/flyoverworks/flyover_comments"
  s.summary     = "Simple commenting gem for Rails 5"
  s.description = "Simple commenting gem for Rails 5"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 5"
  s.add_dependency "jbuilder"
  s.add_dependency "kaminari"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "spring-commands-rspec"
  s.add_development_dependency "spring"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "rb-readline"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "pry-stack_explorer"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "capybara"
  s.add_development_dependency "poltergeist"
end
