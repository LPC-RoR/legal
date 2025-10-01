class CalFeriado < ApplicationRecord

	scope :fecha_ordr, -> {order(:cal_fecha)}
	scope :lv, -> {where(tipo: 'lv')}

	# Devuelve todos los feriados que caen entre semana
	scope :habiles, -> { where("EXTRACT(DOW FROM cal_fecha) NOT IN (0,6)") }

    validates_presence_of :cal_fecha, :descripcion
#	validates :tribunal_corte, uniqueness: true

  # ¿Es día hábil? (no sábado, no domingo, no feriado)
  def self.es_dia_habil?(fecha)
    return false if fecha.on_weekend?
    where(cal_fecha: fecha).none?
  end

  # Calcula la fecha resultado de sumar `dias` hábiles a `fecha_inicial`
  def self.plazo_habil(fecha_inicial, dias)
    raise ArgumentError, "dias debe ser positivo" if dias.negative?

    fecha_inicial ||= Time.zone.today
    fecha = fecha_inicial.to_date
    # --- nuevo bloque -------------------------------------------------
    # Si la fecha inicial no es hábil, se toma el siguiente día hábil
    fecha += 1 while !es_dia_habil?(fecha)
    # -------------------------------------------------------------------
    cont  = 0

    while cont < dias
      fecha = fecha + 1
      cont += 1 if es_dia_habil?(fecha)
    end

    # Asegurarse de que la fecha final sea hábil
    fecha += 1 while !es_dia_habil?(fecha)

    fecha
  end
  
  # Cantidad de días hábiles entre dos fechas (no incluye fecha_inicial)
  def self.dias_habiles_entre(fecha_inicial, fecha_final)
    raise ArgumentError, 'fecha_final debe ser >= fecha_inicial' if fecha_final < fecha_inicial

    (fecha_inicial + 1.day..fecha_final).count { |d| es_dia_habil?(d) }
  end

	def self.plazo_corrido(fecha_inicial, dias)
	    raise ArgumentError, "dias debe ser positivo" if dias.negative?
		fecha_inicial ||= Time.zone.today.to_date
		dias.nil? ? nil : fecha_inicial + dias.day
	end

	# dias corridos para el plazo
	def self.dias_corridos_entre(fecha_inicial, fecha_final)
	    raise ArgumentError, 'fecha_final debe ser >= fecha_inicial' if fecha_final < fecha_inicial
		fecha_inicial ||= Time.zone.today.to_date
		(fecha_inicial.to_date + 1.day..fecha_final.to_date).count
	end

end