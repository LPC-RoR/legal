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

# app/models/simulacion_plazos.rb

  def self.calcular(fecha_base)
    cursor = fecha_base
    ETAPAS.map do |etapa|
      # Etapa 2 (:mismo_dia) comparte ancla con la fecha de recepción;
      # las demás arrancan desde el vencimiento de la etapa anterior.
      anchor = etapa[:inicio] == :mismo_dia ? fecha_base : cursor

      desde, hasta =
        if etapa[:tipo] == "hábiles"
          [siguiente_dia_habil(anchor), sumar_habiles(anchor, etapa[:dias])]
        else
          [anchor + 1, anchor + etapa[:dias]]
        end

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