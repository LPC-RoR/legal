source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby '2.7.1'
# ruby '3.0.0'
ruby '3.3.7'

gem 'pg'

# gem 'bootstrap', '~> 4.5.2'
gem 'bootstrap', '~> 5.3.3'
# gem 'jquery-rails'
gem 'dartsass-sprockets'

gem 'devise'

# paginador
gem 'kaminari'

# excel
# hay que agregarla cuando se migra a ruby 3.4.0 porque ya no viene por defecto es esta versión
gem 'csv'

gem "roo", "~> 2.10.0"
#crear planillas excel
gem 'caxlsx'
gem 'caxlsx_rails'

gem "chartkick"

gem 'carrierwave', '~> 2.0'

# Export to word
gem 'htmltoword'

# Leer PDF files
#gem 'docsplit'
gem 'pdf-reader'

# Vamos por un buscador
# no hay memoria en producción para e
#gem "searchkick"
#gem "opensearch-ruby" # select one
gem 'pg_search'

gem 'stringio', '3.1.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
#gem 'rails', '~> 5.2.6'
gem 'rails', '~> 8.0.1'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier', '>= 1.3.0'
gem 'uglifier'
# See https://github.com/rails/execjs#readme for more supported runtimes
#gem 'mini_racer', '< 0.5.0', platforms: :ruby
#gem 'libv8'
#gem 'mini_racer', platforms: :ruby
#gem 'mini_racer', '>= 0.6.0', platform: :ruby
gem 'execjs'
#gem 'therubyracer' # Optional, if you want a Ruby-based runtime


# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
#  gem 'error_highlight', '>= 0.4.0'
end

# Sacada del grupo development
  gem 'listen' , '~> 3.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
#  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
#  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
