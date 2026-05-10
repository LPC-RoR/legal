# app/jobs/generar_resumen_krn_texto_job.rb
class GenerarResumenKrnTextoJob < ApplicationJob
  queue_as :default

  retry_on ResumenKrnTextoService::OpenAIError, wait: :polynomially_longer, attempts: 3
  retry_on ResumenKrnTextoService::ExtraccionError, wait: 5.seconds, attempts: 2
  discard_on ActiveRecord::RecordNotFound

  def perform(krn_texto_id, nombres_anonimizar = {})
    krn_texto_origen = KrnTexto.find(krn_texto_id)

    # Verifica si ya existe un resumen para este mismo ownr
    if KrnTexto.exists?(ownr: krn_texto_origen.ownr, codigo: "resumen_cronologico")
      Rails.logger.info "[GenerarResumenKrnTextoJob] Resumen ya existe para ownr #{krn_texto_origen.ownr_type}##{krn_texto_origen.ownr_id}. Omitiendo."
      return
    end

    service = ResumenKrnTextoService.new(krn_texto_origen, nombres_anonimizar)
    krn_texto_nuevo = service.generar_resumen!

    Rails.logger.info "[GenerarResumenKrnTextoJob] Resumen generado: KrnTexto ##{krn_texto_nuevo.id} (ownr: #{krn_texto_nuevo.ownr_type}##{krn_texto_nuevo.ownr_id})"
  rescue => e
    Rails.logger.error "[GenerarResumenKrnTextoJob] Error: #{e.message}"
    raise
  end
end