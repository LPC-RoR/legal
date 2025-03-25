source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.7'

gem 'rails', '~> 8.0.1'

gem 'stringio', '3.1.1'

# Base de datos
gem 'pg'
gem 'sqlite3', '~> 1.4', platform: :ruby


# FrontEnd
# Lo necesito para las gemas que usan sprockets
#gem 'sprockets-rails'
gem 'bootstrap', '~> 5.3.3'
gem "dartsass-rails", "~> 0.5.1"
#gem 'dartsass-sprockets'

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
#gem 'uglifier'                    # Compresor de Javascript reemplazada por la de arriba

#gem 'coffee-rails', '~> 4.2'      # Use CoffeeScript for .coffee assets and views

gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
#gem 'turbolinks', '~> 5.2.0'      # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks

gem 'jbuilder'                    # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'execjs'

# Autenticación y autorización
gem 'devise'

# Paginación
gem 'kaminari'

# Manejo de Archivos y exportación
gem 'csv'                         # excel
gem "roo", "~> 2.10.0"            # Leer archivos excel
gem 'caxlsx'                      # Crear planillas excel
gem 'caxlsx_rails'
gem 'carrierwave', '~> 2.0'       # Subir archivos
gem 'htmltoword'                  # Export to word
gem 'pdf-reader'                  # Leer PDF files

gem 'wicked_pdf'                  # Para reportes en PDF
gem 'wkhtmltopdf-binary'

# Busqueda
gem 'pg_search'

# Gráficos
gem "chartkick"

# Servidor y optimización
#gem 'puma', '~> 3.11'
gem "puma", ">= 5.0"
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"


  # Si lo pongo en development me reclama
  gem 'listen' , '~> 3.5'         # Sacada del grupo development

# Development
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw] # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  #gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console', '>= 3.3.0'
#  gem 'spring'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]