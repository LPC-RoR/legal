class KrnDenunciado < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_empleado, optional: true
end
