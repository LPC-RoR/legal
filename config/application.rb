require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Legal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # +++ HCH activa local a :es
    config.i18n.default_locale = :es

    config.time_zone = 'Santiago'
    config.active_record.default_timezone = :local

    config.decimales_pesos = 0
    config.decimales_uf = 5

  end
end
