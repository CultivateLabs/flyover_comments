$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "flyover_comments/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "flyover_comments"
  s.version     = FlyoverComments::VERSION
  s.authors     = ["Ben Roesch"]
  s.email       = ["bcroesch@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of FlyoverComments."
  s.description = "TODO: Description of FlyoverComments."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec", "~> 4.2.8"
  s.add_development_dependency "spring-commands-rspec"
  s.add_development_dependency "spring"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "pry-stack_explorer"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "capybara"
  s.add_development_dependency "poltergeist", "~>1.5"
end
