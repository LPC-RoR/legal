module EmailVerifiable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_verification_token, if: :should_generate_token?
    
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :verification_token, uniqueness: true, allow_nil: true

    scope :verified, -> { where(verified: true) }
    scope :unverified, -> { where(verified: false) }
  end

  def send_verification_email
    generate_verification_token unless verification_token?
    self.verification_sent_at = Time.current
    save!(validate: false) unless new_record?

    VrfccnMailer.verification_email(self.class.name, self.id).deliver_later
  end

  def verify_email(token)
    if verification_token == token
      update(verified: true, verification_token: nil)
    else
      false
    end
  end

  def verified?
    verified
  end

  def verification_expired?
    verification_sent_at < 24.hours.ago
  end

  private

  def generate_verification_token
    self.verification_token = SecureRandom.urlsafe_base64
  end

  def should_generate_token?
    # Sobreescribir en cada modelo según necesidades
    email.present? && (new_record? || email_changed?)
  end
end