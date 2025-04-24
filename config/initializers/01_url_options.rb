# config/initializers/00_force_url_options.rb
Rails.application.config.after_initialize do
  if Rails.env.production?
    ActionMailer::Base.class_eval do
      def default_url_options
        { host: 'www.abogadosderechodeltrabajo.cl', protocol: 'https' }
      end
    end

    Rails.application.routes.named_routes.url_helpers_module.module_eval do
      def default_url_options
        { host: 'www.abogadosderechodeltrabajo.cl', protocol: 'https' }
      end
    end
  end
end