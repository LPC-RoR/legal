# app/models/concerns/email_verifiable.rb
module EmailVerifiable
  extend ActiveSupport::Concern
  
  included do
    before_create :generate_verification_token
  end
  
  def generate_verification_token
    self.verification_token ||= SecureRandom.urlsafe_base64
  end
  
  def email_verified?
    email_ok?
  end
end