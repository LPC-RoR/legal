class AppContacto < ApplicationRecord
	belongs_to :ownr, polymorphic: true

	has_many :pdf_registros, as: :ownr

	validates :nombre, :email, presence: true

	def dflt_bck_rdrccn
		['Cliente', 'Empresa'].include?(self.ownr_type) ? "/cuentas/#{self.ownr_type[0].downcase}_#{self.ownr.id}/nmn" : "/app_contactos"
	end

end