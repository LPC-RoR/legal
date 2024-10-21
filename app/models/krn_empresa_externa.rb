class KrnEmpresaExterna < ApplicationRecord

	ACCTN = 'extrns'

	belongs_to :ownr, polymorphic: true
#	belongs_to :cliente, optional: true

	has_many :krn_denuncia
end
