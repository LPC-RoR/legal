class ProcesadorDemandaJob < ApplicationJob
  queue_as :default

  # 1) Re-intentos por problemas de BD (hasta 5 veces)
  retry_on ActiveRecord::RecordNotFound,
           wait: :exponentially_longer,
           attempts: 5

  # 2) Re-intentos generales (hasta 3 veces)
  retry_on StandardError,
           wait: :exponentially_longer,
           attempts: 3

  # 3) …pero si el error es 429 lo re-encolamos nosotros mismos
  #    con un tiempo fijo (5 min) y sin límite de pasadas
  retry_on StandardError,
           wait: 5.minutes,
           attempts: :unlimited do |job, error|
    error.message.include?('status 429')
  end

  def perform(act_archivo)
    # sanity-check rápido
    return unless act_archivo.persisted? && act_archivo.pdf.attached?

    ProcesadorDemandaService.new(act_archivo).procesar!
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("ActArchivo no encontrado: #{e.message}")
    # no re-lanzamos -> no reintenta más
  rescue StandardError => e
    Rails.logger.error("Error procesando demanda #{act_archivo&.id}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    raise # lo dejamos subir para que los retry_on actúen
  end
end