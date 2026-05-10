# app/jobs/anonimizar_krn_texto_job.rb
class AnonimizarKrnTextoJob < ApplicationJob
  queue_as :default

  retry_on AnonimizarKrnTextoService::OpenAIError, wait: :polynomially_longer, attempts: 3
  retry_on AnonimizarKrnTextoService::ExtraccionError, wait: 5.seconds, attempts: 2
  discard_on ActiveRecord::RecordNotFound

  def perform(krn_texto_id, nombres_anonimizar = {})
    krn_texto_origen = KrnTexto.find(krn_texto_id)

    # Verifica si ya existe un texto anonimizado para este mismo ownr
    if KrnTexto.exists?(ownr: krn_texto_origen.ownr, codigo: "texto_anonimizado")
      Rails.logger.info "[AnonimizarKrnTextoJob] Texto anonimizado ya existe para ownr #{krn_texto_origen.ownr_type}##{krn_texto_origen.ownr_id}. Omitiendo."
      return
    end

    service = AnonimizarKrnTextoService.new(krn_texto_origen, nombres_anonimizar)
    krn_texto_nuevo = service.anonimizar!

    Rails.logger.info "[AnonimizarKrnTextoJob] Texto anonimizado generado: KrnTexto ##{krn_texto_nuevo.id} (ownr: #{krn_texto_nuevo.ownr_type}##{krn_texto_nuevo.ownr_id})"
  rescue => e
    Rails.logger.error "[AnonimizarKrnTextoJob] Error: #{e.message}"
    raise
  end
end