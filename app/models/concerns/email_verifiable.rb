module EmailVerifiable
  extend ActiveSupport::Concern

#  included do
#    after_create :send_verification_email, if: :email_present?
#  end

  def email_present?
    email.present?
  end

  def model_type_name
    self.class.name.underscore.gsub('krn_', '')
  end

  def send_verification_email
    self.verification_token = SecureRandom.urlsafe_base64
    save!
    
    VrfccnMailer.verification_email(self, verification_url).deliver_later
  end

  def verification_url
    url_options = {
      token: verification_token,
      model_type: model_type_name,
      host: appropriate_host,
      protocol: appropriate_protocol
    }
    
    # Solo agregar puerto en desarrollo
    url_options[:port] = 3000 if Rails.env.development?
    
    Rails.application.routes.url_helpers.verify_custom_email_url(url_options)
  end

  private

  def appropriate_host
    Rails.env.production? ? 'www.abogadosderechodeltrabajo.cl' : 'localhost'
  end

  def appropriate_protocol
    Rails.env.production? ? 'https' : 'http'
  end
end