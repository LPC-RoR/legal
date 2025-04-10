class KrnInvestigador < ApplicationRecord

	ACCTN = 'invstgdrs'

	belongs_to :ownr, polymorphic: true

#	has_many :krn_denuncias
	has_many :krn_declaraciones

	has_many :krn_inv_denuncias
	has_many :krn_denuncias, through: :krn_inv_denuncias

	scope :rut_ordr, -> { order(:rut) }

	validates :rut, valida_rut: true
    validates_presence_of :rut, :krn_investigador, :email

	include EmailVerifiable
	after_create :send_verification_email

end
