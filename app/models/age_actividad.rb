class AgeActividad < ApplicationRecord

	D_JC 	= 'Audiencia de juicio'
	PRPRTR 	= 'Audiencia preparatoria'
	UNC 	= 'Audiencia única'
	RNN 	= 'Reunión'

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
	scope :ftrs, -> { where("fecha > ?", Time.zone.today) }

	scope :d_jcs,	-> {where(age_actividad: D_JC)}
	scope :prprtrs,	-> {where(age_actividad: PRPRTR)}
	scope :uncs,	-> {where(age_actividad: UNC)}

    validates_presence_of :age_actividad, :fecha

	after_destroy :update_audiencia

	def update_audiencia
      if @objeto.tipo == 'Audiencia' and @objeto.ownr_type == 'Causa'
        ownr = @objeto.ownr
        adncs = ownr.age_actividades.adncs.ftrs.fecha_ordr
        ownr.fecha_audiencia = adncs.empty? ? nil : adncs.first.fecha
        ownr.audiencia = adncs.empty? ? nil : adncs.first.age_actividad

        ownr.save
      end
	end

	def nombre_creador
		perfil = AppPerfil.find_by(id: self.app_perfil_id)
		if perfil.blank?
			'no encontrado'
		else
			perfil.email == Rails.application.credentials[:dog][:email] ? Rails.application.credentials[:dog][:name] : AppNomina.find_by(email: perfil.email).nombre
		end
	end

	def muted?
		['realizada', 'cancelada'].include?(self.estado) or self.fecha < Time.zone.today
	end

	def text_color
		unless self.fecha.blank?
			if self.muted?
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

	def nm_especial(audiencia_especial)
		audiencia_especial.split(' ')[0] == 'Audiencia' ? audiencia_especial : "Audiencia #{audiencia_especial}"
	end

	def descripcion
		self.audiencia_especial.blank? ? self.age_actividad : nm_especial(self.audiencia_especial)
	end
end
