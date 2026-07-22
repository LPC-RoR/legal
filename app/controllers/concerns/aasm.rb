module Aasm
	extend ActiveSupport::Concern

  def ejecutar_evento
    proceso = params[:proceso]
    evento = params[:evento]

    # Ejecutar
    @objeto.ejecutar_evento(proceso, evento)
    
    redirect_to aasm_rdrccn(@objeto), notice: "✅ Evento ejecutado correctamente"

  rescue ArgumentError => e
    redirect_to aasm_rdrccn(@objeto), alert: "⚠️ #{e.message}"
  rescue AASM::InvalidTransition => e
    redirect_to aasm_rdrccn(@objeto), alert: "❌ Transición no válida: #{e.message}"
  end

  def validar_evento
    # Lista blanca de eventos (seguridad)
    eventos_validos = {
      'operativo' => %w[up_to_archivada dwn_to_tramitacion],
      'financiero' => %w[tu_evento_financiero otro_evento]
    }

    proceso = params[:proceso]
    evento = params[:evento]

    unless eventos_validos[proceso]&.include?(evento)
      redirect_to "/#{@objeto.class.name.tableize}", alert: "❌ Evento no autorizado"
      return false
    end

    # Verificación de estado (usando el método que funciona)
    unless @objeto.evento_permitido?(proceso, evento)
      redirect_to @objeto, alert: "⚠️ No puedes ejecutar '#{evento}' en estado '#{@objeto.send("estado_#{proceso}")}'"
      return false
    end
  end

  private

  def aasm_rdrccn(objt)
    case objt.class.name
    when 'TarServicio'
      objt.ownr_id.blank? ? tabla_path(objt) : "/clientes/#{objt.ownr.id}?html_options[menu]=Tarifas"
    else
      "/#{objt.class.name.tableize}"
    end
  end

end