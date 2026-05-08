# app/jobs/anonimizar_texto_job.rb
class AnonimizarTextoJob < ApplicationJob
  queue_as :default

  retry_on AnonimizarTextoService::OpenAIError, wait: :polynomially_longer, attempts: 3
  retry_on AnonimizarTextoService::ExtraccionError, wait: 5.seconds, attempts: 2
  discard_on ActiveRecord::RecordNotFound

  def perform(act_archivo_id, nombres_anonimizar = {})
    act_archivo = ActArchivo.find(act_archivo_id)

    if KrnTexto.exists?(ownr: act_archivo, codigo: "texto_anonimizado")
      Rails.logger.info "[AnonimizarTextoJob] Texto anonimizado ya existe para ActArchivo ##{act_archivo_id}. Omitiendo."
      return
    end

    service = AnonimizarTextoService.new(act_archivo, nombres_anonimizar)
    krn_texto = service.anonimizar!

    Rails.logger.info "[AnonimizarTextoJob] Texto anonimizado generado: KrnTexto ##{krn_texto.id}"
  rescue AnonimizarTextoService::OpenAIError => e
    Rails.logger.error "[AnonimizarTextoJob] Fallo OpenAI: #{e.message}"
    raise
  rescue AnonimizarTextoService::ExtraccionError => e
    Rails.logger.error "[AnonimizarTextoJob] Fallo extracción PDF: #{e.message}"
    raise
  end
end