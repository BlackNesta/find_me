source "https://rubygems.org"

gem "rails", "~> 8.0.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "sprockets-rails"
gem "dartsass-sprockets"
gem "pg"
gem "puma", ">= 5.0"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
# gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
# gem "thruster", require: false

gem "haml"
gem "bootstrap", "~> 5.3.3"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "devise"
gem "devise-security"
gem "email_validator"
gem "simple_form"
gem "strip_attributes"
gem "country_select"
gem "momentjs-rails"
gem "active_storage_validations"
gem "image_processing"
gem "jquery-rails"
gem "cocoon"
gem "pagy"
gem "ransack"
gem "ransack-enum"
gem "sanitize"
gem "draper"
gem "action_policy"
gem "wicked_pdf"
gem "wkhtmltopdf-binary"
gem "caxlsx_rails"
gem "money-rails"
gem "service_actor"
gem "enumerize"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  gem "letter_opener"

  gem "pry-rails"
  gem "pry-byebug"
end

group :development do
  gem "web-console"
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-rbenv", "~> 2.1"
  gem "capistrano-bundler", require: false
  gem "capistrano3-puma",   require: false
  gem "capistrano-rails-console", require: false
  gem "capistrano-sidekiq", require: false
  gem "better_errors"
  gem "openssl", "~> 3.3", ">= 3.3.2"
end

group :test do
  gem "rspec-rails", "~> 8.0.0"
  gem "factory_bot_rails"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "database_cleaner"
  gem "capybara"
  gem "selenium-webdriver"
  gem "vcr"
  gem "faker"
end
