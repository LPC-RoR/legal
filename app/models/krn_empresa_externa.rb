class KrnEmpresaExterna < ApplicationRecord
	belongs_to :cliente, optional: true
end
