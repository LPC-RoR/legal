class KrnInvestigador < ApplicationRecord
	include EmailVerifiable

	ACCTN = 'invstgdrs'

	belongs_to :ownr, polymorphic: true

	has_many :check_realizados, as: :ownr, dependent: :destroy

	has_many :krn_declaraciones

	has_many :krn_inv_denuncias
	has_many :krn_denuncias, through: :krn_inv_denuncias

	scope :rut_ordr, -> { order(:rut) }

	validates :rut, valida_rut: true
	validates_presence_of :rut, :krn_investigador, :email

	scope :verified, -> { where.not(email_verified_at: nil) }
	scope :unverified, -> { where(email_verified_at: nil) }

	include Cptn

	# En cada modelo (KrnDenunciante, KrnInvestigador, etc.)
	def verified?
	  verification_sent_at.present?
	end

	def tiene_check_realizado?
		check_realizados.exists?(cdg: 'verificar_email',rlzd: true)
	end

	def dflt_bck_rdrccn
		"/cuentas/#{self.ownr.class.name[0].downcase}_#{self.ownr.id}/invstgdrs"
	end
end