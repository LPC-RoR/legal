source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.7'

gem 'rails', '~> 8.0.1'

gem 'stringio', '3.1.1'

# Necesario para no hace rails assets:precompile en development
# Borrado porque genera un problema con PropShaft
# gem 'sprockets-rails'

# para desplegar articulos bonitos
gem 'meta-tags'


# Base de datos
gem 'pg'
gem 'sqlite3', '~> 1.4', platform: :ruby

# Seguridad
# Rack::Attack (rate limiting por IP)
gem 'rack-attack'

# FrontEnd
gem "dartsass-rails", "~> 0.5.1"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

#gem 'coffee-rails', '~> 4.2'      # Use CoffeeScript for .coffee assets and views

gem "turbo-rails"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Gemfile para evitar conflicto de los :delete
#gem 'rails-ujs'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

gem 'jbuilder'                    # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'execjs'

# Autenticación y autorización
gem 'devise'
# Para manejor roles de Usuarios
gem 'rolify'
# Para manejar autorizaciones
gem 'pundit'
# Para el manejo de Tenants
gem 'request_store'

gem 'sidekiq'          # or delayed_job / resque

# Para verificar envío de correos en el navegador
gem 'letter_opener', group: :development

# Paginación
gem 'kaminari'

# Gemfile
gem 'image_processing', '~> 1.2'

# Manejo de Archivos y exportación
gem 'csv'                         # excel
gem "roo", "~> 2.10.0"            # Leer archivos excel
gem 'caxlsx'                      # Crear planillas excel
gem 'caxlsx_rails'
gem 'carrierwave', '~> 2.0'       # Subir archivos
gem 'htmltoword'                  # Export to word
gem 'pdf-reader'                  # Leer PDF files
# Gemfile
gem 'combine_pdf', '~> 1.0'
gem 'prawn'           # crea el PDF anonimizado
gem 'prawn-table'       # si hay tablas
gem 'prawn-markup', '~> 1.1'
gem 'ruby-openai'       # NER (puedes usar spaCy vía API propia)

gem 'rtesseract'          # wrapper de Tesseract-OCR
gem 'mini_magick'         # convertir pdf → png

gem 'wicked_pdf'                  # Para reportes en PDF
gem 'wkhtmltopdf-binary'

# Gemfile
gem 'grover'                      # Para reportes en PDF con bootstrap 5

gem 'mime-types'
gem 'rqrcode'
gem 'chunky_png'  # Necesario para convertir el QR a imagen

# Busqueda
gem 'pg_search'

# Gráficos
gem "chartkick"
gem "rails_charts"

# Evaluación de expresiones
gem "dentaku"

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
gem "cssbundling-rails", "~> 1.4"

gem "marcel", "~> 1.0"

gem "ruby-filemagic", "~> 0.7.3"
