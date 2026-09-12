class SimulacionPlazos
  ETAPAS = [
    { numero: 1, nombre: "Recepción de denuncia",  dias: 3,  tipo: "hábiles",
      descripcion: "Trámites propios de la recepción",                   inicio: :siguiente_habil },
    { numero: 2, nombre: "Investigación",          dias: 30, tipo: "hábiles",
      descripcion: "Investigar los hechos denunciados",                  inicio: :mismo_dia },
    { numero: 3, nombre: "Depósito del informe",   dias: 2,  tipo: "hábiles",
      descripcion: "Remitir informe a la Dirección del Trabajo",         inicio: :siguiente_habil },
    { numero: 4, nombre: "Pronunciamiento DT",     dias: 30, tipo: "hábiles",
      descripcion: "Plazo legal para pronunciamiento de la DT",          inicio: :siguiente_habil },
    { numero: 5, nombre: "Aplicación de medidas",  dias: 15, tipo: "corridos",
      descripcion: "Aplicar medidas y sanciones propuestas",             inicio: :siguiente_corridos }
  ].freeze

  def self.calcular(fecha_base)
    cursor = fecha_base
    ETAPAS.map do |etapa|
      desde = case etapa[:inicio]
              when :mismo_dia           then cursor
              when :siguiente_habil     then siguiente_dia_habil(cursor)
              when :siguiente_corridos  then cursor + 1
              end
      hasta = etapa[:tipo] == "hábiles" ? sumar_habiles(desde, etapa[:dias]) : desde + etapa[:dias]
      cursor = hasta
      etapa.merge(desde: desde, hasta: hasta, icono: "bi-calendar-event", color: "primary")
    end
  end

  def self.sumar_habiles(desde, dias)
    fecha = desde
    dias.times { fecha = siguiente_dia_habil(fecha) }
    fecha
  end

  def self.siguiente_dia_habil(fecha)
    fecha += 1
    fecha += 1 while fecha.on_weekend? || feriado?(fecha)
    fecha
  end

  # Conecta aquí tu fuente real de feriados de Chile (tabla, gema chilean-cl, API, etc.)
  def self.feriado?(fecha)
    CalFeriado.exists?(cal_fecha: fecha) # ajustar según tu modelo real
  end
end