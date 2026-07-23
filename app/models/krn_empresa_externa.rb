class KrnEmpresaExterna < ApplicationRecord

	include VerificacionEmails
	include RutNormalizable

	TIPOS = ['Contrato', 'EST']

	ACCTN = 'extrns'

	belongs_to :ownr, polymorphic: true

	has_many :check_realizados, as: :ownr, dependent: :destroy

	has_many :krn_denuncias
	has_many :krn_derivaciones

	# Método que me entrega el hacs id => razon_social
	# Alternativa usando pluck (más eficiente para ActiveRecord::Relation)
	def self.to_options_hash
		pluck(:id, :razon_social).to_h
	end

	# REVISAR desde aquí

    validates_presence_of :rut, :razon_social, :contacto, :email
	def dflt_bck_rdrccn
		"/cuentas/#{self.ownr.class.name[0].downcase}_#{self.ownr.id}/extrns"
	end

	# En cada modelo (KrnDenunciante, KrnInvestigador, etc.)
	# verification_sent_at marca recepción de la verificación, se añade email == email_ok para manejar cambios de email
	def verified?
	  verification_sent_at.present? and email == email_ok
	end

end