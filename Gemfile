source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Authentication
gem 'devise'
gem 'omniauth'
gem 'omniauth-oauth2', '~> 1.3.1'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'omniauth-github'

gem 'bootstrap-sass', '~> 3.3.6'

gem 'pry'

# Background processing
gem 'sidekiq', '>= 4.0.0'
gem 'sinatra', require: false
gem 'slim'
gem 'sidekiq-status'

# File management
gem "paperclip", "~> 4.3"

# eventmachine webserver
gem 'tubesock'
gem 'puma'

# call request to Phylo web services
gem 'rest-client'

# Multiple table inheritance
gem 'active_record-acts_as'

# Tree representation
gem "d3-rails", "3.5.16"

# Carousel
gem 'jquery-slick-rails'

# paginate
gem 'will_paginate'
gem 'bootstrap-will_paginate', '0.0.10'
gem "font-awesome-rails"

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# search
# gem 'sunspot_rails'
# gem 'sunspot_solr' # optional pre-packaged Solr distribution for use in development

# unzip files
gem 'rubyzip', '>= 1.0.0'

# read sheet
gem 'roo', '~> 2.3.2'

# copy clipboard
gem 'clipboard-rails'

# html to pdf
gem 'wkhtmltopdf-binary-edge', '~> 0.12.2.1'
gem 'wicked_pdf'

gem 'jquery-ui-rails'

gem 'jquery-cookie-rails'

gem 'redis-namespace'

gem 'newick-ruby'

gem 'jquery-minicolors-rails'

gem 'raphael-rails'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

group :production do
  gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.2'
  # gem 'capistrano', '~> 3.1.0', require: false
#   gem 'capistrano-bundler', '1.1.1', require: false
#   gem 'capistrano-rails', '1.1.0', require: false
#   gem 'capistrano3-puma', require: false
end
