# Ejecuta un paso de la secuencia de seguimiento.
# Aborta silenciosamente si el lead ya fue gestionado por un humano
# (estado distinto de nuevo/contactado): el pipeline manual manda.
class Comercial::SeguimientoLeadJob < ApplicationJob
  queue_as :default

  # Se descarta sin reintentos si el lead fue eliminado entre medias.
  discard_on ActiveRecord::RecordNotFound

  def perform(lead, paso)
    return unless lead.seguimiento_activo?

    tipo = case paso
           when "agendar" then "agendar"
           when "cierre"  then "cierre"
           else lead.segmento_seguimiento # paso "medio": se decide con la info más fresca
           end

    Comercial::LeadMailer.with(lead: lead, tipo: tipo).seguimiento.deliver_later
  end
end
