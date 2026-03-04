class AppNomina < ApplicationRecord

	include VerificacionEmails

	ACCTN = 'nmn'

	TIPOS = ['operación', 'finanzas', 'general', 'admin']

	belongs_to :ownr, polymorphic: true, optional: true

	has_many :check_realizados, as: :ownr, dependent: :destroy

	has_one :app_perfil

	validates :nombre, :email, presence: true
	validates :email, uniqueness: true

	scope :gnrl, -> { where(ownr_id: nil)}

	scope :nombre_ordr, -> { order(:nombre) }

	def dflt_bck_rdrccn
		['Cliente', 'Empresa'].include?(self.ownr_type) ? "/cuentas/#{self.ownr_type[0].downcase}_#{self.ownr.id}/nmn" : "/app_nominas"
	end

	def self.dog
		find_by(email: Rails.application.credentials[:dog][:email])		
	end

	def self.activa(usuario)
		find_by(email: usuario.email)
	end

	def dog?
		self.ownr_type == 'AppVersion'
	end

	def dominio
		self.ownr.class.name
	end

	# DEPRECATED Antiguo 'perfil'
	def perfil2
		perfil = AppPerfil.find_by(email: self.email)
	end

	# En cada modelo (KrnDenunciante, KrnInvestigador, etc.)
	# verification_sent_at marca recepción de la verificación, se añade email == email_ok para manejar cambios de email
	def verified?
	  verification_sent_at.present? and email == email_ok
	end

end