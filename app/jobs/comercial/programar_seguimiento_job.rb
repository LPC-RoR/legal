# Encola la secuencia de seguimiento automático al crearse un lead:
#   +1 día hábil  → paso :agendar  (recordatorio de agendamiento)
#   +3 días hábiles → paso :medio   (plantilla elegida por Lead::Segmentacion)
#   +7 días corridos → paso :cierre (último contacto)
#
# Idempotente: marca el lead la primera vez y no reprograma si ya hay
# seguimiento en curso (el controlador solo lo invoca tras un create exitoso,
# pero el guard protege contra dobles submits o re-procesos).
class Comercial::ProgramarSeguimientoJob < ApplicationJob
  queue_as :default

  def perform(lead)
    return if lead.seguimiento_programado_en.present?

    lead.update_column(:seguimiento_programado_en, Time.current)

    Comercial::SeguimientoLeadJob.set(wait_until: habiles_desde(Date.current, 1)).perform_later(lead, "agendar")
    Comercial::SeguimientoLeadJob.set(wait_until: habiles_desde(Date.current, 3)).perform_later(lead, "medio")
    Comercial::SeguimientoLeadJob.set(wait_until: 7.days.from_now).perform_later(lead, "cierre")
  end

  private

  # Time a n días hábiles de distancia, saltando sábados y domingos.
  # Los feriados de Chile quedan fuera de alcance: el margen de 24–72 h
  # comercial hace que el efecto de un feriado intercalado sea menor.
  #
  # Nota: ActiveJob exige un Time en `wait_until` (le aplica `to_f`), no un Date:
  # por eso el resultado se convierte con `in_time_zone`.
  def habiles_desde(fecha, n)
    dia = fecha
    while n.positive?
      dia += 1
      n -= 1 unless dia.saturday? || dia.sunday?
    end
    dia.in_time_zone
  end
end