class AgeActividad < ApplicationRecord

#	belongs_to :app_perfil

	has_many :age_antecedentes

	has_many :age_usu_acts
	has_many :age_usuarios, through: :age_usu_acts

	# Revisar DEPRECATED
	has_many :age_act_perfiles
	has_many :app_perfiles, through: :age_act_perfiles

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def nombre_creador
		AppPerfil.find(self.app_perfil_id).nombre_perfil
	end

	def text_color
		['Audiencia', 'Hito'].include?(self.tipo) ? 'primary' : ( (self.estado == 'realizada' or self.fecha < Time.zone.today) ? 'muted' : self.prioridad )
	end

	def abr_encargados
		usuarios = self.age_usuarios
		usuarios.empty? ? 'Sin encargados' : ( usuarios.count == 1 ? usuarios.first.age_usuario : "#{usuarios.first.age_usuario} + #{usuarios.count - 1}" )
	end
end
