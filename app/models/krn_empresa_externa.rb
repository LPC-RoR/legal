class KrnEmpresaExterna < ApplicationRecord
	belongs_to :cliente, optional: true

	has_many :krn_denuncia
end
