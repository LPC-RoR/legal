class AgeActividad < ApplicationRecord

#	belongs_to :app_perfil

	has_many :age_antecedentes

	has_many :age_usu_acts
	has_many :age_usuarios, through: :age_usu_acts

	# Revisar DEPRECATED
	has_many :age_act_perfiles
	has_many :app_perfiles, through: :age_act_perfiles

	has_many :age_logs

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def nombre_creador
		perfil = AppPerfil.find_by(id: self.app_perfil_id)
		perfil.blank? ? 'no encontrado' : perfil.nombre_perfil
	end

	def text_color
		if (['realizada', 'cancelada'].include?(self.estado) or self.fecha < Time.zone.today)
			'muted'
		else
			case self.tipo
			when 'Audiencia'
				'primary'
			when 'Hito'
				'dark'
			when 'Reunión'
				'success'
			when 'Tarea'
				'info'
			end
		end
	end

	def abr_encargados
		usuarios = self.age_usuarios
		usuarios.empty? ? 'Sin encargados' : ( usuarios.count == 1 ? usuarios.first.age_usuario : "#{usuarios.first.age_usuario} + #{usuarios.count - 1}" )
	end

	def nm_especial(audiencia_especial)
		audiencia_especial.split(' ')[0] == 'Audiencia' ? audiencia_especial : "Audiencia #{audiencia_especial}"
	end

	def descripcion
		self.audiencia_especial.blank? ? self.age_actividad : nm_especial(self.audiencia_especial)
	end
end
