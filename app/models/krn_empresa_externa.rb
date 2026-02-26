class KrnEmpresaExterna < ApplicationRecord

	TIPOS = ['Contrato', 'EST']

	ACCTN = 'extrns'

	belongs_to :ownr, polymorphic: true

	has_many :check_realizados, as: :ownr, dependent: :destroy

	has_many :krn_denuncias
	has_many :krn_derivaciones

	validates :rut, valida_rut: true
    validates_presence_of :rut, :razon_social, :contacto, :email
	def dflt_bck_rdrccn
		"/cuentas/#{self.ownr.class.name[0].downcase}_#{self.ownr.id}/extrns"
	end

	# En cada modelo (KrnDenunciante, KrnInvestigador, etc.)
	# verification_sent_at marca recepción de la verificación, se añade email == email_ok para manejar cambios de email
	def verified?
	  verification_sent_at.present? and email == email_ok
	end

	def tiene_check_realizado?
		check_realizados.exists?(cdg: 'verificar_email',rlzd: true)
	end

end