# app/models/krn_denuncia.rb
module KrnPlazos
  extend ActiveSupport::Concern

  # ============================================================
  # ACCESO RÁPIDO A TRÁMITES
  # ============================================================

  def tramite(tipo)
    krn_tramites.find_by(tipo: tipo)
  end

  def tramite_deposito
    @tramite_deposito ||= tramite('deposito_investigacion')
  end

  def tramite_aviso_inicio
    @tramite_aviso_inicio ||= tramite('aviso_inicio_investigacion')
  end

  def tramite_derivacion_dt
    @tramite_derivacion_dt ||= tramite('derivacion_denuncia_dt')
  end

  # ============================================================
  # FECHAS DE CUMPLIMIENTO (ahora desde trámites)
  # ============================================================

  # Plazo recepción: derivación a DT o aviso de inicio de investigación
  def fecha_cumplimiento_recepcion
    tramite_derivacion_dt&.fecha_tramite || tramite_aviso_inicio&.fecha_tramite
  end

  # Plazo depósito informe: trámite de depósito de investigación
  def fecha_deposito_informe
    tramite_deposito&.fecha_tramite
  end

  # ============================================================
  # FECHAS LÍMITE DE PLAZOS
  # ============================================================
  # --- Cálculo de fechas límite (retornan Date) ---

  def plazo_recepcion_fecha
    CalFeriado.plazo_habil(fecha_hora&.to_date, 3)
  end

  def plazo_investigacion_fecha
    CalFeriado.plazo_habil(fecha_hora&.to_date, 30)
  end

  def plazo_deposito_informe_fecha
    base = fecha_termino_investigacion || plazo_investigacion_fecha
    CalFeriado.plazo_habil(base, 2)
  end

  def plazo_pronunciamiento_fecha
    base = fecha_deposito_informe || plazo_deposito_informe_fecha
    CalFeriado.plazo_habil(base, 30)
  end

  def plazo_aplicacion_medidas_fecha
    base = fecha_recepcion_pronunciamiento || plazo_pronunciamiento_fecha
    CalFeriado.plazo_corrido(base, 15)
  end

  # ============================================================
  # ESTRUCTURA UNIFICADA DE PLAZOS
  # ============================================================

  def plazos
    @plazos ||= [
      build_plazo_recepcion,
      build_plazo_investigacion,
      build_plazo_deposito,
      build_plazo_pronunciamiento,
      build_plazo_aplicacion
    ]
  end

  # --- Helpers de consulta rápida ---

  def plazos_cumplidos
    plazos.select { |p| p[:estado] == :cumplido }
  end

  def plazos_pendientes
    plazos.reject { |p| p[:estado] == :cumplido }
  end

  def plazos_vencidos_o_incumplidos
    plazos.select { |p| [:vencido, :incumplido].include?(p[:estado]) }
  end

  def alerta_activa?
    plazos.any? { |p| p[:estado] == :proximo } ||
      plazos.any? { |p| p[:aprobado_por_vencimiento] }
  end

  private

  # ============================================================
  # CONSTRUCTORES DE CADA PLAZO
  # ============================================================

  def build_plazo_recepcion
    cumplimiento = fecha_cumplimiento_recepcion
    limite = plazo_recepcion_fecha

    build_plazo(
      nombre: 'Recepción de denuncia',
      dias: 3,
      tipo: 'hábiles',
      fecha_limite: limite,
      fecha_cumplimiento: cumplimiento,
      referencia: fecha_hora&.to_date,
      tarea: 'Ingreso de denuncia al sistema',
      observacion: observacion_recepcion
    )
  end

  def build_plazo_investigacion
    build_plazo(
      nombre: 'Investigación',
      dias: 30,
      tipo: 'hábiles',
      fecha_limite: plazo_investigacion_fecha,
      fecha_cumplimiento: fecha_termino_investigacion,
      referencia: fecha_hora&.to_date,
      tarea: 'Término de investigación'
    )
  end

  def build_plazo_deposito
    build_plazo(
      nombre: 'Depósito del informe',
      dias: 2,
      tipo: 'hábiles',
      fecha_limite: plazo_deposito_informe_fecha,
      fecha_cumplimiento: fecha_deposito_informe,
      referencia: fecha_termino_investigacion || plazo_investigacion_fecha,
      tarea: 'Remitir informe a Dirección del Trabajo',
      observacion: observacion_deposito
    )
  end

  def build_plazo_deposito
    build_plazo(
      nombre: 'Depósito del informe',
      dias: 2,
      tipo: 'hábiles',
      fecha_limite: plazo_deposito_informe_fecha,
      fecha_cumplimiento: fecha_deposito_informe,
      referencia: fecha_termino_investigacion || plazo_investigacion_fecha,
      tarea: 'Remitir informe a Dirección del Trabajo',
      observacion: fecha_termino_investigacion ? nil : 'Investigación aún no finaliza'
    )
  end

  def build_plazo_pronunciamiento
    limite = plazo_pronunciamiento_fecha
    aprobado = !fecha_recepcion_pronunciamiento && vencido?(limite)

    build_plazo(
      nombre: 'Pronunciamiento Dirección del Trabajo',
      dias: 30,
      tipo: 'hábiles',
      fecha_limite: limite,
      fecha_cumplimiento: fecha_recepcion_pronunciamiento,
      referencia: fecha_deposito_informe || plazo_deposito_informe_fecha,
      tarea: 'Recibir pronunciamiento DT',
      observacion: observacion_pronunciamiento(limite),
      aprobado_por_vencimiento: aprobado
    )
  end

  def build_plazo_aplicacion
    build_plazo(
      nombre: 'Aplicación de medidas y sanciones',
      dias: 15,
      tipo: 'corridos',
      fecha_limite: plazo_aplicacion_medidas_fecha,
      fecha_cumplimiento: fecha_aplicacion_medidas,
      referencia: fecha_recepcion_pronunciamiento || plazo_pronunciamiento_fecha,
      tarea: 'Aplicar medidas y sanciones propuestas',
      observacion: observacion_aplicacion
    )
  end

  # ============================================================
  # MOTOR DE ESTADOS
  # ============================================================

  def build_plazo(nombre:, dias:, tipo:, fecha_limite:, fecha_cumplimiento:, referencia:, tarea:, observacion: nil, aprobado_por_vencimiento: false)
    estado = calcular_estado(fecha_limite, fecha_cumplimiento, tipo)

    {
      nombre: nombre,
      dias: dias,
      tipo: tipo,
      fecha_limite: fecha_limite,
      fecha_cumplimiento: fecha_cumplimiento,
      referencia: referencia,
      tarea: tarea,
      estado: estado,
      observacion: observacion,
      aprobado_por_vencimiento: aprobado_por_vencimiento,
      dias_restantes: calcular_dias_restantes(fecha_limite, estado, tipo),
      incumplido: estado == :incumplido
    }
  end

  def calcular_estado(limite, cumplimiento, tipo)
    return :cumplido   if cumplimiento.present? && (limite.nil? || cumplimiento <= limite)
    return :incumplido if cumplimiento.present? && limite.present? && cumplimiento > limite
    return :vencido    if limite.present? && limite < Date.current
    return :proximo    if limite.present? && proximo_a_vencer?(limite, tipo)

    :pendiente
  end

  def vencido?(fecha)
    fecha.present? && fecha < Date.current
  end

  def proximo_a_vencer?(limite, tipo)
    return false unless limite.present?

    restantes = if tipo == 'hábiles'
                  CalFeriado.dias_habiles_entre(Date.current, limite)
                else
                  (limite - Date.current).to_i
                end

    restantes >= 0 && restantes <= 3
  end

  def calcular_dias_restantes(limite, estado, tipo)
    return 0 if [:cumplido, :vencido, :incumplido].include?(estado)
    return nil unless limite.present?

    if tipo == 'hábiles'
      CalFeriado.dias_habiles_entre(Date.current, limite)
    else
      (limite - Date.current).to_i
    end
  end

  # ============================================================
  # OBSERVACIONES CONTEXTUALES
  # ============================================================

  def observacion_recepcion
    if tramite_derivacion_dt.present?
      "Denuncia derivada a la DT (Solicitud ##{tramite_derivacion_dt.numero_solicitud})"
    elsif tramite_aviso_inicio.present?
      "Investigación interna informada a la DT (Solicitud ##{tramite_aviso_inicio.numero_solicitud})"
    else
      'Pendiente: denuncia aún no derivada ni informada a la DT'
    end
  end

  def observacion_deposito
    if tramite_deposito.present?
      "Depósito registrado (Solicitud ##{tramite_deposito.numero_solicitud})"
    elsif fecha_termino_investigacion.nil?
      'Investigación aún no finaliza'
    else
      'Informe aún no depositado'
    end
  end

  def observacion_pronunciamiento(limite)
    if fecha_recepcion_pronunciamiento
      nil
    elsif vencido?(limite)
      'Plazo vencido. Informe dado por aprobado. Proceder a aplicar medidas y sanciones.'
    elsif fecha_deposito_informe.nil?
      'Informe aún no depositado'
    else
      'En espera de pronunciamiento'
    end
  end

  def observacion_aplicacion
    if fecha_aplicacion_medidas
      nil
    elsif fecha_recepcion_pronunciamiento.nil? && vencido?(plazo_pronunciamiento_fecha)
      'Plazo de pronunciamiento vencido. Aplicación desde fecha de vencimiento del plazo anterior.'
    elsif fecha_recepcion_pronunciamiento.nil?
      'Pronunciamiento aún no recibido'
    else
      'En plazo para aplicación'
    end
  end
end