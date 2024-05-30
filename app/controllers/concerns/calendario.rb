module Calendario
  extend ActiveSupport::Concern

  def load_calendario
    @hoy = Time.zone.today

    @n_annio = params[:annio_sem].blank? ? @hoy.year : params[:annio_sem].split('_')[0].to_i
    @n_semana = params[:annio_sem].blank? ? get_n_semana(@hoy) : params[:annio_sem].split('_')[1].to_i

    lunes = Date.commercial(@n_annio, @n_semana + 1, 1)
    anterior = lunes - 7.day
    siguiente = lunes + 7.day
    @params_anterior = "#{anterior.year}_#{get_n_semana(anterior)}"
    @params_siguiente = "#{siguiente.year}_#{get_n_semana(siguiente)}"

    # SEGUNDA VERSION
    @week = days_n_sem(@n_annio, @n_semana)
    set_tabla('lu-age_actividades', AgeActividad.where(fecha: @week[0].all_day).order(:fecha), false)
    set_tabla('ma-age_actividades', AgeActividad.where(fecha: @week[1].all_day).order(:fecha), false)
    set_tabla('mi-age_actividades', AgeActividad.where(fecha: @week[2].all_day).order(:fecha), false)
    set_tabla('ju-age_actividades', AgeActividad.where(fecha: @week[3].all_day).order(:fecha), false)
    set_tabla('vi-age_actividades', AgeActividad.where(fecha: @week[4].all_day).order(:fecha), false)
    set_tabla('sa-age_actividades', AgeActividad.where(fecha: @week[5].all_day).order(:fecha), false)
    set_tabla('do-age_actividades', AgeActividad.where(fecha: @week[6].all_day).order(:fecha), false)
  end

  # ------------------------------------------- GENERAL

  # obtiene el némero de la semana
  def get_n_semana(dt_dia)
    # Para los gringos el domingo es de la semana siguiente
    # si el día es domingo hay que restarle uno para que quede bien
    en_n_semana = dt_dia.strftime('%U').to_i
    nombre_dia(dt_dia) == 'domingo' ? en_n_semana - 1 : en_n_semana
  end

  # n_semana, comienza con la semana 1 ( la del primero de enero )
  # Pero Date.commercial asume que la primera es la número 0 => le sumamos 1 para usarla
  # curiosamente en los días parte de 0
  def days_n_sem(n_year, n_semana)
    days = []
    for ndia in 1..7 do
      days << Date.commercial(n_year, n_semana + 1, ndia)
    end
    days
  end

  # Entrega indice del día de dt_fecha en el arreglo
  def day_index(dt_fecha)
    ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].find_index(dt_fecha.strftime('%A'))
  end

  # Si es lunes, es el mismo día, si no, el lunes pasado
  def lunes_dt(dt_fecha)
    dt_fecha - day_index(dt_fecha).day
  end

  def nombre_dia(dt_fecha)
    ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'][day_index(dt_fecha)]
  end

  def prfx_dia(dt_fecha)
    ['lu', 'ma', 'mi', 'ju', 'vi', 'sa', 'do'][day_index(dt_fecha)]
  end

  def nombre3_dia(dt_fecha)
    nombre_dia(dt_fecha)[0..2]
  end

  def dyf(dt_fecha)
    nombre_dia(dt_fecha) == 'domingo' or CalFeriado.find_by(cal_fecha: dt_fecha).present?
  end

  #------------------------------------------------------------------------------------------------------------------------

  # VERIFICAR Se usa en tablas controller, para verificar que el año existe antes de desplegar la tabla REVISAR
  def verifica_annio_activo
    hoy = Time.zone.today
    annio_actual = CalAnnio.find_by(cal_annio: @clave_annio)
    if annio_actual.blank?
      annio_actual = CalAnnio.create(cal_annio: hoy.year)
      (1..12).to_a.each do |numero_mes|
        CalMes.create(cal_mes: numero_mes, cal_annio_id: annio_actual.id, clave: "#{annio_actual.cal_annio} #{numero_mes}")
      end
    end
    if hoy.month > 6
      siguiente = CalAnnio.find_by(cal_annio: hoy.year + 1)
      if siguiente.blank?
        siguiente = CalAnnio.create(cal_annio: hoy.year + 1)
        (1..12).to_a.each do |numero_mes|
          CalMes.create(cal_mes: numero_mes, cal_annio_id: siguiente.id, clave: "#{siguiente.cal_annio} #{numero_mes}")
        end
      end
    end
  end

end