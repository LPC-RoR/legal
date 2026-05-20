# app/helpers/causas_helper.rb
module AppEstadoFinancieroHelper
  # Mapeo de eventos a labels amigables
  EVENTOS_FINANCIEROS = {
    marcar_facturable:       { label: 'Marcar como Facturable',       clase: 'btn-info' },
    marcar_con_facturaciones:{ label: 'Marcar con Facturaciones',   clase: 'btn-primary' },
    marcar_facturada:        { label: 'Marcar como Facturada',        clase: 'btn-warning' },
    marcar_cobrada:          { label: 'Marcar como Cobrada',          clase: 'btn-success' },
    volver_a_ingreso:        { label: 'Volver a Ingreso',             clase: 'btn-outline-secondary' },
    volver_a_facturable:     { label: 'Volver a Facturable',          clase: 'btn-outline-secondary' },
    volver_a_con_facturaciones: { label: 'Volver a Con Facturaciones', clase: 'btn-outline-secondary' },
    volver_a_facturada:      { label: 'Volver a Facturada',           clase: 'btn-outline-secondary' }
  }.freeze

  # SOLO MIENTRAS DURA LA MIGRACION
  # app/controllers/causas_controller.rb
  def migrar_estado_financiero
    @causa = Causa.find(params[:id])
    
    # Mapeo de estados antiguos a nuevos
    mapeo = {
      'sin_cobros' => 'ingreso',
      'con_cobros' => 'con_facturaciones',  # o 'facturable', según corresponda
      'cobrada'    => 'cobrada',
      'facturada'  => 'facturada',
      'cerrada'    => 'cobrada'             # o el que definas
    }

    nuevo_estado = mapeo[@causa.estado_financiero]

    if nuevo_estado && @causa.update_column(:estado_financiero, nuevo_estado)
      redirect_to @causa, notice: "Estado migrado de '#{@causa.estado_financiero_was}' a '#{nuevo_estado}'"
    else
      redirect_to @causa, alert: "No se pudo migrar el estado"
    end
  end

  def botones_estado_financiero(causa)
    eventos_permitidos = causa.aasm(:financiero).events(permitted: true).map(&:name)

    safe_join(eventos_permitidos.map do |evento|
      config = EVENTOS_FINANCIEROS[evento] || { label: evento.to_s.humanize, clase: 'btn-secondary' }

      button_to(
        config[:label],
        cambiar_estado_financiero_causa_path(causa),
        method: :patch,
        params: { evento: evento },
        class: "btn #{config[:clase]} btn-sm me-2 mb-2",
        data: { confirm: "¿Confirmar cambio a '#{config[:label]}'?" }
      )
    end)
  end

  # Badge con el estado actual
  def badge_estado_financiero(causa)
    clases = {
      'ingreso'           => 'bg-secondary',
      'facturable'        => 'bg-info',
      'con_facturaciones' => 'bg-primary',
      'facturada'         => 'bg-warning text-dark',
      'cobrada'           => 'bg-success'
    }

    content_tag(:span, causa.estado_financiero.humanize, class: "badge #{clases[causa.estado_financiero] || 'bg-secondary'}")
  end
end