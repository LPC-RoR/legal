class AgeUsuario < ApplicationRecord

	belongs_to :app_perfil, optional: true

	has_many :age_usu_acts
	has_many :age_actividades, through: :age_usu_acts

	has_many :age_pendientes

end
