# config/initializers/01_url_options.rb
Rails.application.reloader.to_prepare do
  if Rails.env.production?
    options = { host: 'www.abogadosderechodeltrabajo.cl', protocol: 'https' }
    
    Rails.application.routes.default_url_options = options
    Rails.application.config.action_mailer.default_url_options = options
    ActionMailer::Base.default_url_options = options
    
    puts "URL options FORZADAS en producción: #{options.inspect}" if Rails.env.development?
  end
end