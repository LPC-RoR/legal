module EmailVerifiable
  extend ActiveSupport::Concern

  def email_present?
    respond_to?(:email) && email.present?
  end

  def model_type_name
    self.class.name.underscore # => "com_requerimiento", "krn_denunciante", etc.
  end

  def send_verification_email
    self.verification_token = SecureRandom.urlsafe_base64
    self.n_vrfccn_lnks = (self.n_vrfccn_lnks || 0) + 1
    self.fecha_vrfccn_lnk = Time.zone.now
    save!

    VrfccnMailer.verification_email(self, verification_url).deliver_later
    self.update_column(:verification_sent_at, Time.current) # marca hora de envío
  end

  def verification_url
    url_options = {
      token: verification_token,
      model_type: model_type_name,
      host: appropriate_host,
      protocol: appropriate_protocol
    }
    url_options[:port] = 3000 if Rails.env.development?
    Rails.application.routes.url_helpers.verify_custom_email_url(url_options)
  end

  private

  def appropriate_host
    Rails.env.production? ? 'www.laborsafe.cl' : 'localhost'
  end

  def appropriate_protocol
    Rails.env.production? ? 'https' : 'http'
  end
end