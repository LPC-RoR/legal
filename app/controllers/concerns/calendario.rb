module Calendario
  extend ActiveSupport::Concern

  def load_calendario

    # objtiene @cal_annio, si no viene en el parámetro, usa el del día de hoy
    n_annio = params[:annio_sem].blank? ? @hoy.year : params[:annio_sem].split('_')[0].to_i
    # si el annio no existe lo crea, si no tiene meses los crea
    @cal_annio = busca_y_puebla_annio(n_annio)

    # Hasta aquí tenemos el año y sus meses

    # obtiene @cal_semana, si no hay parámetro busca la del dia de hoy
    n_semana = params[:annio_sem].blank? ? get_n_semana(@hoy) : params[:annio_sem].split('_')[1].to_i
    # WARNING : revisar si @hoy.month sirve para este método
    @cal_semana = busca_y_puebla_semana(@cal_annio, n_semana)

    @dias_semana = @cal_semana.cal_dias.order(:dt_fecha)
    @lunes = @dias_semana.first
    @domingo = @dias_semana.last

    @params_anterior = params_semana_anterior(@cal_semana)
    @params_siguiente = params_semana_siguiente(@cal_semana)

    @age_usuarios = AgeUsuario.where(owner_class: '', owner_id: nil)

    @dias_semana = @cal_semana.cal_dias.order(:dt_fecha)
    @vector_dias = @dias_semana.map {|ds| {dia: ds.dt_fecha, dyf: ds.dyf? ? 'danger' : 'primary', actividades: AgeActividad.where(fecha: ds.dt_fecha.all_day).order(:fecha) } }

    @v_semana = []

    @dias_semana.each do |cal_dia|
      dia = {}
      dia[:dia] = cal_dia.dt_fecha
      dia[:dyf] = cal_dia.dyf? ? 'danger' : 'primary'
      dia[:actividades] = AgeActividad.where(fecha: cal_dia.dt_fecha.all_day).order(:fecha)

      @v_semana << dia
    end

  end

  # ------------------------------------------- GENERAL

  def cal_nombre_dias
    {
      'Monday' => 'lunes',
      'Tuesday' => 'martes',
      'Wednesday' => 'miércoles',
      'Thursday' => 'jueves',
      'Friday' => 'viernes',
      'Saturday' => 'sábado',
      'Sunday' => 'domingo'
    }
  end

  def get_cal_dia(fecha)
    annio = CalAnnio.find_by(cal_annio: fecha.year)
     if annio.blank?
      nil
    else
      mes = annio.cal_meses.find_by(cal_mes: fecha.month)
      if mes.blank?
        nil
      else
        mes.cal_dias.find_by(cal_dia: fecha.day)
      end
    end
  end

  # obtiene el último día del mes
  # Se obtiene buscado el dia siguiente (primer día del mes siguiente)
  # y restándole un día
  def ultimo_dia_mes(cal_mes)
    n_year_mes = cal_mes.cal_annio.cal_annio
    n_year_first = cal_mes.cal_mes == 12 ? n_year_mes + 1 : n_year_mes
    n_month_first = cal_mes.cal_mes == 12 ? 1 : cal_mes.cal_mes + 1
    siguiente_dia = DateTime.new(n_year_first, n_month_first,1)
    ultimo = siguiente_dia -1
    ultimo.day
  end

  def dias_del_mes(cal_mes)
    (1..ultimo_dia_mes(cal_mes)).to_a
  end

  # obtiene el némero de la semana
  def get_n_semana(datetime)
    # Para los gringos el domingo es de la semana siguiente
    # si el día es domingo hay que restarle uno para que quede bien
    en_n_semana = datetime.strftime('%U').to_i
    nombre_dia(datetime) == 'domingo' ? en_n_semana - 1 : en_n_semana
  end

  # Traduce al español nombre del día obtenido de la fecha
  def nombre_dia(datetime)
    datetime.blank? ? 'error' : cal_nombre_dias[datetime.strftime('%A')]
  end

  def nombre3_dia(datetime)
    cal_nombre_dias[datetime.strftime('%A')][0..2]
  end

  def clave_mes(datetime)
    "#{datetime.year} #{datetime.month}"
  end

  def clave_dia(datetime)
    "#{datetime.year} #{datetime.month} #{datetime.day}"
  end

  # ------------------------------------------- BUSCA Y PUEBLA

  # Busca año y lo entrega, si no lo encuentra, lo crea y lo puebla de meses
  def busca_y_puebla_annio(n_annio)
    cal_annio = CalAnnio.find_by(cal_annio: n_annio)
    cal_annio = CalAnnio.create(cal_annio: n_annio) if cal_annio.blank?
    if cal_annio.cal_meses.empty?
      (1..12).to_a.each do |numero_mes|
        CalMes.create(cal_mes: numero_mes, cal_annio_id: cal_annio.id, clave: "#{cal_annio.cal_annio} #{numero_mes}")
      end
    end
    cal_annio
  end


  # Puebla el mes con las semanas que le corresponden
  def poblar_cal_mes(cal_mes)
    dias_del_mes(cal_mes).each do |numero_dia|
      # para obtener el número de la semana, primero debemos
      dt_dia = Time.zone.parse("#{numero_dia}-#{cal_mes.cal_mes}-#{cal_mes.cal_annio.cal_annio}")
      n_semana = get_n_semana(dt_dia)

      cal_semana = cal_mes.cal_semanas.find_by(cal_semana: n_semana)
      cal_semana = cal_mes.cal_semanas.create(cal_semana: n_semana) if cal_semana.blank?

      # El campo dt_fecha sirve para encontrar un cal_dia sin necesidad de la estructura si se tiene la fecha
      cal_dia = CalDia.find_by(dt_fecha: dt_dia)
      CalDia.create(cal_dia: numero_dia, dt_fecha: dt_dia, dia_semana: nombre_dia(dt_dia), cal_mes_id: cal_mes.id, cal_semana_id: cal_semana.id) if cal_dia.blank?
    end
  end

  # Busca el numero de la semana en el año
  # cal_annio = @annio
  # se llama después de llamar busca_y_puebla_annio, lo que garantiza que cal_annio y cal_mes existen
  def busca_y_puebla_semana(cal_annio, n_semana)
    busca_semana = nil
    cal_annio.cal_meses.order(:cal_mes).each do |cal_mes|
      poblar_cal_mes(cal_mes) if cal_mes.cal_semanas.empty?
      busca_semana = cal_mes.cal_semanas.find_by(cal_semana: n_semana) if busca_semana.blank?
    end
    busca_semana
  end

  def params_semana_anterior(cal_semana)
    fecha_lunes = cal_semana.cal_dias.order(:dt_fecha).first.dt_fecha
    fecha_domingo_anterior = fecha_lunes - 1.day
    cal_domingo = CalDia.find_by(dt_fecha: fecha_domingo_anterior)
    if cal_domingo.blank?
      n_annio = fecha_domingo_anterior.year
      cal_annio = busca_y_puebla_annio(n_annio)
      cal_semana = busca_y_puebla_semana(cal_annio, get_n_semana(fecha_domingo_anterior) )
      "#{cal_annio.cal_annio}_#{cal_semana.cal_semana}"
    else
      "#{cal_domingo.cal_mes.cal_annio.cal_annio}_#{cal_domingo.cal_semana.cal_semana}"
    end
  end

  def params_semana_siguiente(cal_semana)
    fecha_domingo = cal_semana.cal_dias.order(:dt_fecha).last.dt_fecha
    fecha_lunes_siguiente = fecha_domingo + 1.day
    cal_lunes = CalDia.find_by(dt_fecha: fecha_lunes_siguiente)
    if cal_lunes.blank?
        n_annio = fecha_lunes_siguiente.year
        cal_annio = busca_y_puebla_annio(n_annio)
        cal_semana = busca_y_puebla_semana(cal_annio, get_n_semana(fecha_lunes_siguiente) )
        "#{cal_annio.cal_annio}_#{cal_semana.cal_semana + 1}"
    else
        "#{cal_lunes.cal_mes.cal_annio.cal_annio}_#{cal_lunes.cal_semana.cal_semana}"
    end
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