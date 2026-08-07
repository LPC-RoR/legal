module Calendario
  extend ActiveSupport::Concern

  # ------------------------------------------- GENERAL

  # Entrega indice del día de dt_fecha en el arreglo
  def day_index(dt_fecha)
    ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].find_index(dt_fecha.strftime('%A'))
  end

  def nombre_dia(dt_fecha)
    ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'][day_index(dt_fecha)]
  end

  def prfx_dia(dt_fecha)
    ['lu', 'ma', 'mi', 'ju', 'vi', 'sa', 'do'][day_index(dt_fecha)]
  end

  def dyf(dt_fecha)
    (nombre_dia(dt_fecha) == 'domingo') or CalFeriado.where(cal_fecha: dt_fecha.beginning_of_day..dt_fecha.end_of_day).any?
  end

end