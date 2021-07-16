source 'https://rubygems.org'
ruby '2.6.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.3'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2.3'

# Use SCSS for stylesheets
gem 'sassc-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 5.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.0', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.3'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.10'

# Automatically add rel="noopener noreferrer" to every link with target="_blank"
gem 'safe_target_blank'

# Create filters easily with scopes
gem 'has_scope'

# Annotate database fields to model files
gem 'annotate', '>=2.6.1'

# Secure Password Hashes
gem 'bcrypt', '~> 3.1.13'

# Ruby linting
gem 'rubocop'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 1.1.0', require: false
end

group :development, :test do
  gem 'rspec-rails', '~> 4.0'
  gem 'rspec-mocks'
  gem 'rake'
  gem 'letter_opener'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'capybara'
  gem 'rails_log_stdout',           git: 'https://github.com/heroku/rails_log_stdout.git'
  gem 'byebug'
end

gem 'web-console', group: :development

gem 'simplecov', group: :test, require: nil

# basic layouting
# gem 'twitter-bootstrap-rails'

# bootstrap 3
gem 'bootstrap-rails-engine'

# open ID gem for user activation
gem 'ruby-openid'
gem 'open_id_authentication'

# authorizations in one place
gem 'cancancan', '~> 3.1'

# simple http requests
gem 'rest-client'

# command line parsing for project registration
gem 'highline'

# for picture Upload
gem 'paperclip', '~> 6.1.0'

# for cron jobs
gem 'whenever'

# add some more UI controls
gem 'jquery-ui-rails'

# jquery plugin for rating stars
gem 'jquery-raty-rails', git: 'https://github.com/bmc/jquery-raty-rails.git'

# load jQuery fast without refresh
gem 'jquery-turbolinks'

# a Helper to validate dates
gem 'validates_timeliness', '~> 4.1'

# replacement for glyphicons
gem 'font-awesome-rails'

# pagination
gem 'will_paginate', '~> 3.3'

# styles pagination with bootstrap
gem 'will_paginate-bootstrap'

gem 'active_enum', git: 'https://github.com/adzap/active_enum.git'
gem 'jquery-star-rating-rails'
gem 'simple_form'

# Translatable ActiveRecord attributes
gem 'traco'

# WYSIWYG Text Editor
gem 'tinymce-rails', '~> 5.8'
gem 'tinymce-rails-langs', '~> 5.20200505'
gem 'sanitize', '~> 5.2'

# Birthdate validation
gem 'chronic', '~> 0.10.2'

group :test do
  gem 'email_spec'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'poltergeist'
  gem 'rails-controller-testing'
end

# flags
gem 'famfamfam_flags_rails'

# saves config settings in a database
gem 'configurable_engine'

# asset handling for heroku
gem 'rails_serve_static_assets'

# error reporting with sentry
gem 'sentry-raven'

# deployment with nginx and unicorn
gem 'unicorn'
gem 'capistrano', '~> 3.13'
gem 'capistrano-rails', '~> 1.6'
gem 'capistrano-bundler'
gem 'capistrano-rvm'
