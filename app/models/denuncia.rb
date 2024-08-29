class Denuncia < ApplicationRecord
	belongs_to :cliente
	belongs_to :receptor_denuncia
	belongs_to :alcance_denuncia
	belongs_to :motivo_denuncia
	belongs_to :dependencia_denunciante

	has_many :denunciados

end
