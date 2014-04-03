source 'https://rubygems.org'

ruby '2.0.0'

gem 'airbrake'
gem 'attr_extras'
gem 'bourbon', '>= 3.2.0.beta.2'
gem 'clearance'
gem 'cocaine'
gem 'coffee-rails'
gem 'delayed_job_active_record', '>= 4.0.0'
gem 'email_validator'
gem 'flutie'
gem 'friendly_id'
gem 'github-markdown', require: 'github/markdown'
gem 'haml'
gem 'high_voltage'
gem 'jquery-rails'
gem 'neat'
gem 'omniauth-oauth2'
gem 'pg'
gem 'rack-timeout'
gem 'rails', '>= 4.0.0'
gem 'recipient_interceptor'
gem 'sass-rails', '4.0.1'
gem 'simple_form'
gem 'uglifier'
gem 'unicorn'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'rspec-rails', '>= 2.14'
end

group :test do
  gem 'capybara-webkit', '>= 1.0.0'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'sinatra', require: false
  gem 'timecop'
  gem 'webmock'
end

group :staging, :production do
  gem 'newrelic_rpm', '>= 3.6.7'
  gem 'rails_12factor'
end
