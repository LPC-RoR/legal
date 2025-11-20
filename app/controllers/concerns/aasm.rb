module Aasm
	extend ActiveSupport::Concern

  def ejecutar_evento
    proceso = params[:proceso]
    evento = params[:evento]

    # Ejecutar
    @objeto.ejecutar_evento(proceso, evento)
    
    redirect_to causas_path, notice: "✅ Evento ejecutado correctamente"

  rescue ArgumentError => e
    redirect_to causas_path, alert: "⚠️ #{e.message}"
  rescue AASM::InvalidTransition => e
    redirect_to causas_path, alert: "❌ Transición no válida: #{e.message}"
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
      redirect_to causas_path, alert: "❌ Evento no autorizado"
      return false
    end

    # Verificación de estado (usando el método que funciona)
    unless @objeto.evento_permitido?(proceso, evento)
      redirect_to @objeto, alert: "⚠️ No puedes ejecutar '#{evento}' en estado '#{@objeto.send("estado_#{proceso}")}'"
      return false
    end
  end

end