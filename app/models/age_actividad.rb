class AgeActividad < ApplicationRecord

#	belongs_to :app_perfil
	belongs_to :ownr, polymorphic: true

	has_many :age_usu_acts
	has_many :age_usuarios, through: :age_usu_acts

	has_many :age_logs

	has_many :notas, as: :ownr

	scope :fecha_ordr, -> {order(:fecha)}
	scope :fecha_d_ordr, -> {order(fecha: :desc)}
	scope :pndnts, -> {where(estado: 'pendiente')}
	scope :sspondds, -> {where(estado: 'suspendida')}
	scope :adncs, -> {where(tipo: 'Audiencia')}

    validates_presence_of :age_actividad

	def nombre_creador
		perfil = AppPerfil.find_by(id: self.app_perfil_id)
		if perfil.blank?
			'no encontrado'
		else
			perfil.email == AppVersion::DOG_EMAIL ? AppVersion::DOG_NAME : AppNomina.find_by(email: perfil.email).nombre
		end
	end

	def text_color
		unless self.fecha.blank?
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
		else
			'muted'
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
