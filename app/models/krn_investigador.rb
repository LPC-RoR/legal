class KrnInvestigador < ApplicationRecord

	ACCTN = 'invstgdrs'

	belongs_to :ownr, polymorphic: true

#	has_many :krn_denuncias
	has_many :krn_declaraciones

	has_many :krn_inv_denuncias
	has_many :krn_denuncias, through: :krn_inv_denuncias

	after_create :send_verification_email

	scope :rut_ordr, -> { order(:rut) }

	validates :rut, valida_rut: true
    validates_presence_of :rut, :krn_investigador, :email

	after_create :send_verification_email

	scope :verified, -> { where.not(email_verified_at: nil) }
	scope :unverified, -> { where(email_verified_at: nil) }

	# En cada modelo (KrnDenunciante, KrnInvestigador, etc.)
	def verified?
	  verification_sent_at.present?
	end

  private

  def send_verification_email
    self.verification_token = SecureRandom.urlsafe_base64
    self.save!
    verification_url = Rails.application.routes.url_helpers.verify_custom_email_url(
      token: self.verification_token,
      model_type: 'investigador',
      host: 'localhost:3000'
    )
    VrfccnMailer.verification_email(self, verification_url).deliver_now
  end

end