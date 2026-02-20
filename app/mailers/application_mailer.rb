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

end