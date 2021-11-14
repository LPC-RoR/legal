class StPerfilModelo < ApplicationRecord
	belongs_to :app_nomina

	has_many :st_perfil_estados
end
