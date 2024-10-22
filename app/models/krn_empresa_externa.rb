class KrnEmpresaExterna < ApplicationRecord

	ACCTN = 'extrns'

	belongs_to :ownr, polymorphic: true

	has_many :krn_denuncia

	validates :rut, valida_rut: true
    validates_presence_of :rut, :razon_social, :contacto, :email_contacto
end
