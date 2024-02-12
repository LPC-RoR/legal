module Calendario
  extend ActiveSupport::Concern

  def ultimo_dia_mes(year, month)
    month == 12 ? (DateTime.new(year+1,1,1)-1).day : (DateTime.new(year, month+1,1)-1).day
  end

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

  def nombre_dia(datetime)
    cal_nombre_dias[datetime.strftime('%A')]
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

  # ULTIMA VERSION
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

  # ULTIMA VERSION
  # es igual a verifica_mes(cal_mes)
  def poblar_cal_mes(cal_mes)
    (1..ultimo_dia_mes(cal_mes.cal_annio.cal_annio, cal_mes.cal_mes)).to_a.each do |numero_dia|
      dt_dia = Time.zone.parse("#{numero_dia}-#{cal_mes.cal_mes}-#{cal_mes.cal_annio.cal_annio}")
      n_semana = get_n_semana(dt_dia)

      cal_semana = CalSemana.find_by(cal_semana: n_semana)
      cal_semana = CalSemana.create(cal_semana: n_semana) if cal_semana.blank?

      cal_mes.cal_semanas << cal_semana unless cal_mes.cal_semanas.ids.include?(cal_semana.id)

      cal_dia = CalDia.find_by(dt_fecha: dt_dia)
      CalDia.create(cal_dia: numero_dia, dt_fecha: dt_dia, dia_semana: nombre_dia(dt_dia), cal_mes_id: cal_mes.id, cal_semana_id: cal_semana.id) if cal_dia.blank?
    end
  end

  # ULTIMA VERSION
  def busca_y_puebla_semana(annio, n_semana, n_mes)
    n_busqueda = n_mes.blank? ? (12 / n_semana).to_i : n_mes
    cal_mes = annio.cal_meses.find_by(cal_mes: n_busqueda)
    if cal_mes.cal_semanas.empty?
      poblar_cal_mes(cal_mes)
    end
    cal_semana = cal_mes.cal_semanas.find_by(cal_semana: n_semana)
    if cal_semana.blank?
      cal_semanas = cal_mes.cal_semanas.order(:cal_semana)
      cal_semanas.first.cal_semana > n_semana ? busca_y_puebla_semana(annio, n_semana, cal_mes.cal_mes - 1) : busca_y_puebla_semana(annio, n_semana, cal_mes.cal_mes + 1)
    else
      cal_semana
    end
  end

  def params_semana_anterior(semana)
    lunes = semana.cal_dias.order(:dt_fecha).first.dt_fecha
    domingo_buscado = CalDia.find_by(dt_fecha: (lunes - 1.day))
    if domingo_buscado.blank?
      annio = (lunes-1).year
      annio_buscado = busca_y_puebla_annio(annio)
      semana_buscada = busca_y_puebla_semana(annio_buscado, get_n_semana(lunes - 1), (lunes - 1).month )
      "#{annio_buscado.cal_annio}_#{semana_buscada.cal_semana - 1}"
    else
      "#{domingo_buscado.cal_mes.cal_annio.cal_annio}_#{domingo_buscado.cal_semana.cal_semana}"
    end
  end

  def params_semana_siguiente(semana)
    domingo = semana.cal_dias.order(:dt_fecha).last.dt_fecha
    lunes_buscado = CalDia.find_by(dt_fecha: (domingo + 1.day))
    if lunes_buscado.blank?
        annio = (domingo + 1).year
        annio_buscado = busca_y_puebla_annio(annio)
        semana_buscada = busca_y_puebla_semana(annio_buscado, get_n_semana(domingo + 1), (domingo + 1).month )
        "#{annio_buscado.cal_annio}_#{semana_buscada.cal_semana - 1}"
    else
        "#{lunes_buscado.cal_mes.cal_annio.cal_annio}_#{lunes_buscado.cal_semana.cal_semana}"
    end
  end
  #------------------------------------------------------------------------------------------------------------------------

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

  def get_n_semana(datetime)
    en_n_semana = datetime.strftime('%U').to_i
    nombre_dia(datetime) == 'domingo' ? en_n_semana - 1 : en_n_semana
  end

  def verifica_mes(cal_mes)
    (1..ultimo_dia_mes(cal_mes.cal_annio.cal_annio, cal_mes.cal_mes)).to_a.each do |numero_dia|
      dt_dia = Time.zone.parse("#{numero_dia}-#{cal_mes.cal_mes}-#{cal_mes.cal_annio.cal_annio}")
      n_semana = get_n_semana(dt_dia)

      cal_semana = CalSemana.find_by(cal_semana: n_semana)
      cal_semana = CalSemana.create(cal_semana: n_semana) if cal_semana.blank?

      cal_mes.cal_semanas << cal_semana unless cal_mes.cal_semanas.ids.include?(cal_semana.id)

      cal_dia = CalDia.find_by(dt_fecha: dt_dia)
      CalDia.create(cal_dia: numero_dia, dt_fecha: dt_dia, dia_semana: nombre_dia(dt_dia), cal_mes_id: cal_mes.id, cal_semana_id: cal_semana.id) if cal_dia.blank?
    end
  end

end