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

	def resend_user_welcome_email(reset_password: true)  # <-- Default true
	  usuario = Usuario.find_by(email: email)
	  return { success: false, error: 'Usuario no encontrado' } if usuario.nil?

	  # Siempre generar nueva contraseña al reenviar
	  new_password = Devise.friendly_token.first(12)
	  usuario.password = new_password
	  usuario.password_confirmation = new_password
	  
	  unless usuario.save
	    return { success: false, error: usuario.errors.full_messages.join(', ') }
	  end

	  Contexts::Platform::AccountMailer
	    .welcome_email(usuario.id, new_password)
	    .deliver_now

	  { success: true, message: 'Correo reenviado con nueva contraseña' }
	rescue => e
	  Rails.logger.error "Error en resend_user_welcome_email: #{e.message}"
	  { success: false, error: e.message }
	end

end