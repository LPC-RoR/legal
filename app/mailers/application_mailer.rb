# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  # MultiMails
#  include TenantMailer
#  include TrackableDelivery

  default from: 'no-reply@laborsafe.cl'
  # Versión antigua
  # layout 'mailer'

  # MultiMails
  # Layout determinado por contexto automáticamente
  layout 'mailers/base'

  before_action :set_active_storage_url_options

  before_action :set_branding

  helper_method :current_branding, :logo_url, :footer_html, :brand_name, :support_email

  private

  # MultiMails *
  # Todos los métodos hacia abajo

  def tenant_present?
    @tenant.present?
  end

  def set_branding
    # Usa @tenant si está definido, si no intenta current_tenant (para compatibilidad)
    tenant = @tenant || (respond_to?(:current_tenant) ? current_tenant : nil)
    
    return unless tenant

    @branding = tenant.branding_for(mail_context)
  end

  def mail_context
    self.class.name.split('::')[1]&.underscore&.to_sym || :default
  end
  
  def set_context_metadata
    @brand_logo = current_tenant.logo_url
    @support_email = context_support_email
    @unsubscribe_url = generate_unsubscribe_link
  end
  
  # Delegación segura a @branding con valores por defecto
  def current_branding; @branding; end
  
  def logo_url; @branding&.logo_url; end
  def footer_html; @branding&.footer_html; end
  def brand_name; @branding&.brand_name; end
  def support_email; @branding&.support_email; end

  private

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = active_storage_url_options
  end

  # ¡Cambiamos el nombre para evitar conflicto con el método nativo url_options!
  def active_storage_url_options
    {
      host: mailer_host,
      protocol: mailer_protocol,
      port: mailer_port
    }.compact
  end

  def mailer_host
    ActionMailer::Base.default_url_options[:host] ||
      Rails.application.routes.default_url_options[:host] ||
      Rails.application.config.action_mailer.default_url_options&.dig(:host) ||
      environment_fallback_host
  end

  def mailer_protocol
    ActionMailer::Base.default_url_options[:protocol] ||
      Rails.application.config.action_mailer.default_url_options&.dig(:protocol) ||
      'https'
  end

  def mailer_port
    port = ActionMailer::Base.default_url_options[:port] ||
           Rails.application.routes.default_url_options[:port]
    
    # No incluir puerto si es el default del protocolo
    return nil if port.blank? || 
                  (mailer_protocol == 'https' && port.to_i == 443) ||
                  (mailer_protocol == 'http' && port.to_i == 80)
    
    port
  end

  def environment_fallback_host
    case Rails.env
    when 'production'
      raise ArgumentError, 
            "ERROR: config.action_mailer.default_url_options[:host] no está configurado en production. " \
            "Añade: config.action_mailer.default_url_options = { host: 'tudominio.com' } en config/environments/production.rb"
    when 'development'
      'localhost:3000'
    when 'test'
      'www.example.com'
    else
      'localhost:3000'
    end
  end

end