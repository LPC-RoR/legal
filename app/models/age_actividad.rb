class AgeActividad < ApplicationRecord

#	belongs_to :app_perfil

	has_many :age_antecedentes

	has_many :age_act_perfiles
	has_many :app_perfiles, through: :age_act_perfiles

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end
end
