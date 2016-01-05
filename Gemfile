source 'https://rubygems.org'

ruby "2.2.3"

# Server & DB
gem 'rails', '4.2.5'
gem 'puma'
gem 'pg', '~> 0.15'

# HTML, CSS and JS Stack
gem 'slim-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'bootstrap-sass'
gem 'font-awesome-sass'

# App Specific
gem 'omniauth-pocket'
gem 'simple_form'
gem 'enumerize'
gem 'rails_utils'
gem 'http'
gem 'ahoy_email'

# Queue
gem 'sidekiq'

# Errors
gem 'party_foul'

# Monitoring
gem "skylight"

group :staging, :production do
  gem "rails_12factor"
  gem "heroku-deflater"
end

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'dotenv-rails'
end

group :development do
  gem 'spring'
  gem 'web-console'
  gem 'letter_opener'
end

group :test do
  gem 'faker'
  gem 'webmock'
  gem 'shoulda'
end

gem 'nokogiri', '>= 1.6.7.1'
