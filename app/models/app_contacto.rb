class AppContacto < ApplicationRecord

	include VerificacionEmails

	belongs_to :ownr, polymorphic: true

	has_many :check_realizados, as: :ownr, dependent: :destroy

	validates :nombre, :email, presence: true

	def rol_contacto
		grupo = 'RRHH' ? 'revisión de datos' : (grupo == 'Apt' ? 'coordinador Apt' : 'sin rol definido')
	end

	def kywrd
		{
			rol: 	rol_contacto,
			abrev: 	"cntct-#{id}",
			sym: 	:cntct,
			krn: 	"cntct-#{id}-0"
		}
	end

	def dflt_bck_rdrccn
		['Cliente', 'Empresa'].include?(self.ownr_type) ? "/cuentas/#{self.ownr_type[0].downcase}_#{self.ownr.id}/nmn" : "/app_contactos"
	end

	def sym
		:cntct
	end


	## DEPRECATED tiene reemplazo en en tiene_email_verificado?
	# En cada modelo (KrnDenunciante, KrnInvestigador, etc.)
	# verification_sent_at marca recepción de la verificación, se añade email == email_ok para manejar cambios de email
	def verified?
	  verification_sent_at.present? and email == email_ok
	end

end