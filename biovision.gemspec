$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "biovision/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "biovision"
  spec.version     = Biovision::VERSION
  spec.authors     = ["Maxim Khan-Magomedov"]
  spec.email       = ["maxim.km@gmail.com"]
  spec.homepage    = "https://github.com/Biovision/biovision"
  spec.summary     = "Biovision CMS gem"
  spec.description = "Better version of biovision-base for rails 6."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0", ">= 6.0.2.1"
  spec.add_dependency 'rails-i18n', '~> 6.0'

  spec.add_dependency 'bcrypt', '~> 3.1'
  spec.add_dependency 'carrierwave', '~> 2.0'
  spec.add_dependency 'carrierwave-bombshelter', '~> 0.2'
  spec.add_dependency 'kaminari', '~> 1.1'
  spec.add_dependency 'mini_magick', '~> 4.9', '>= 4.9.5'
  spec.add_dependency 'rest-client', '~> 2.1'

  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'rspec-rails'
end
