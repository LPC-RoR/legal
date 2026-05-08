class KrnInvestigador < ApplicationRecord

	include VerificacionEmails
	
	ACCTN = 'invstgdrs'

	belongs_to :ownr, polymorphic: true

	has_many :act_referencias, as: :ref
	has_many :check_realizados, as: :ownr, dependent: :destroy

	has_many :krn_declaraciones

	has_many :krn_inv_denuncias
	has_many :krn_denuncias, through: :krn_inv_denuncias

	# KrnTexto se usa para guardar texto personalizado para ser insertado en los reportes
	# el campo 'codigo' es el código del reporte
	has_many :krn_textos, as: :ownr, dependent: :destroy
	accepts_nested_attributes_for :krn_textos, allow_destroy: true

	scope :rut_ordr, -> { order(:rut) }

	validates :rut, valida_rut: true
	validates_presence_of :rut, :krn_investigador, :email

	scope :verified, -> { where.not(email_verified_at: nil) }
	scope :unverified, -> { where(email_verified_at: nil) }

	include Cptn

	def dflt_bck_rdrccn
		"/cuentas/#{self.ownr.class.name[0].downcase}_#{self.ownr.id}/invstgdrs"
	end

	# En cada modelo (KrnDenunciante, KrnInvestigador, etc.)
	# verification_sent_at marca recepción de la verificación, se añade email == email_ok para manejar cambios de email
	def verified?
	  verification_sent_at.present? and email == email_ok
	end

end