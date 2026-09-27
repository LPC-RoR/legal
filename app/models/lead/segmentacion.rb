# Encapsula la lógica comercial de "qué seguimiento le corresponde a cada lead".
# Usado por Comercial::SeguimientoLeadJob para elegir la plantilla del paso medio
# y para saber si el lead sigue siendo elegible para seguimiento automático.
module Lead::Segmentacion
  extend ActiveSupport::Concern

  # El seguimiento automático solo corre mientras el lead no ha sido gestionado
  # por un humano (contactado en adelante) ni descartado.
  def seguimiento_activo?
    nuevo? || contactado?
  end

  # ¿Tiene sentido invitarlo a "agendar" con un enlace directo al formulario?
  # Solo cuando su punto de entrada fue una herramienta (autodiagnóstico o
  # simulador): ahí el formulario de contacto ES el agendamiento.
  # Quien ya llenó el formulario simple ("Conversemos sobre las necesidades de
  # su empresa") queda en espera de que un especialista lo contacte: invitarlo
  # a llenar el mismo formulario de nuevo es un bucle.
  def invitar_agendamiento_directo?
    diagnostico? || %w[simulador diagnostico].include?(fuente)
  end

  # Plantilla del paso medio (+3 días hábiles), según lo declarado en el autodiagnóstico.
  # Prioridad comercial: urgencia real > riesgo de imparcialidad > ausencia de
  # investigador > brecha de trámite DT > prevención genérica.
  def segmento_seguimiento
    return "prevencion" unless diagnostico?

    case respuesta(:denuncia_abierta)
    when "si", "tramite"
      "urgencia"
    else
      case respuesta(:investigador_actual)
      when "interno" then "imparcialidad"
      when "nadie"   then "protocolo"
      else
        %w[no parcial].include?(respuesta(:informe_dt)) ? "dt" : "prevencion"
      end
    end
  end
end
