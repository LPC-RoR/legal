# app/models/concerns/email_verifiable.rb
module EmailVerifiable
  extend ActiveSupport::Concern

  # Métodos de clase disponibles al incluir el concern
  class_methods do
    def envia_verificacion_despues_crear
      after_create_commit :send_verification_email
    end
  end

  def email_present?
    respond_to?(:email) && email.present?
  end

  def model_type_name
    self.class.name.underscore
  end

  def send_verification_email
    # 2️⃣ everything that must be persisted before the mail
    #     is sent is done in a single update
    update!(
      verification_token:   SecureRandom.urlsafe_base64,
      n_vrfccn_lnks:        (n_vrfccn_lnks || 0) + 1,
      fecha_vrfccn_lnk:     Time.zone.now,
      verification_sent_at: Time.current
    )

    VrfccnMailer.with(
      user_class:     self.class.name,
      user_id:        id,
      verification_url: verification_url,
      tenant_id:      current_tenant_id
    ).verification_email.deliver_later
  end

  def verification_url
    opts = {
      token:      verification_token,
      model_type: model_type_name,
      host:       appropriate_host,
      protocol:   appropriate_protocol
    }
    opts[:port] = 3000 if Rails.env.development?
    Rails.application.routes.url_helpers.verify_custom_email_url(opts)
  end

  private

  def appropriate_host
    Rails.env.production? ? 'www.laborsafe.cl' : 'localhost'
  end

  def appropriate_protocol
    Rails.env.production? ? 'https' : 'http'
  end

  def current_tenant_id
    defined?(::Current) && ::Current.respond_to?(:tenant) ? ::Current.tenant&.id : nil
  end
end