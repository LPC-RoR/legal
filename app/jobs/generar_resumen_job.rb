# app/jobs/generar_resumen_job.rb
class GenerarResumenJob < ApplicationJob
  queue_as :default

  retry_on ResumenDocumentoService::OpenAIError, wait: :polynomially_longer, attempts: 3
  retry_on ResumenDocumentoService::ExtraccionError, wait: 5.seconds, attempts: 2
  discard_on ActiveRecord::RecordNotFound

  # Recibe nombres_anonimizar como parámetro del job
  def perform(act_archivo_id, nombres_anonimizar = {})
    act_archivo = ActArchivo.find(act_archivo_id)

    # Debug: ahora sí usa el parámetro correcto
    Rails.logger.info "=== DEBUG HASH ==="
    nombres_anonimizar.each do |k, v|
      Rails.logger.info "Hash key: #{k} => #{v}"
      Rails.logger.info "Hash key bytes: #{k.bytes.inspect}"
    end

    if KrnTexto.exists?(ownr: act_archivo, codigo: "resumen_cronologico")
      Rails.logger.info "[GenerarResumenJob] Resumen ya existe para ActArchivo ##{act_archivo_id}. Omitiendo."
      return
    end

    service = ResumenDocumentoService.new(act_archivo, nombres_anonimizar)
    krn_texto = service.generar_resumen!

    Rails.logger.info "[GenerarResumenJob] Resumen generado exitosamente: KrnTexto ##{krn_texto.id}"
  rescue ResumenDocumentoService::OpenAIError => e
    Rails.logger.error "[GenerarResumenJob] Fallo OpenAI para ActArchivo ##{act_archivo_id}: #{e.message}"
    raise
  rescue ResumenDocumentoService::ExtraccionError => e
    Rails.logger.error "[GenerarResumenJob] Fallo extracción PDF para ActArchivo ##{act_archivo_id}: #{e.message}"
    raise
  end
end