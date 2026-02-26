class AppContacto < ApplicationRecord
	belongs_to :ownr, polymorphic: true

	has_many :check_realizados, as: :ownr, dependent: :destroy

	has_many :pdf_registros, as: :ref

	validates :nombre, :email, presence: true

	def dflt_bck_rdrccn
		['Cliente', 'Empresa'].include?(self.ownr_type) ? "/cuentas/#{self.ownr_type[0].downcase}_#{self.ownr.id}/nmn" : "/app_contactos"
	end

	def sym
		:cntct
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