class AgeUsuario < ApplicationRecord

	has_many :age_usu_perfiles
	has_many :app_perfiles, through: :age_usu_perfiles

	has_many :age_usu_acts
	has_many :age_actividades, through: :age_usu_acts

end
