class KrnEmpresaExterna < ApplicationRecord

	TIPOS = ['Contrato', 'EST']

	ACCTN = 'extrns'

	belongs_to :ownr, polymorphic: true

	has_many :krn_denuncias
	has_many :krn_derivaciones

	validates :rut, valida_rut: true
    validates_presence_of :rut, :razon_social, :contacto, :email_contacto

	def dflt_bck_rdrccn
		"/cuentas/#{self.ownr.class.name[0].downcase}_#{self.ownr.id}/extrns"
	end

end