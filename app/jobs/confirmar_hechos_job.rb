# app/jobs/confirmar_hechos_job.rb
class ConfirmarHechosJob < ApplicationJob
  queue_as :default

  retry_on ConfirmarHechosService::OpenAIError, wait: :polynomially_longer, attempts: 3
  retry_on ConfirmarHechosService::ExtraccionError, wait: 5.seconds, attempts: 2
  discard_on ActiveRecord::RecordNotFound

  def perform(krn_texto_id, act_archivo_id, nombres_anonimizar: {}, tipo_declarante:, nombres_denunciantes: [], nombres_denunciados: [])
    declaracion = KrnTexto.find(krn_texto_id)
    denuncia = ActArchivo.find(act_archivo_id)

    if KrnTexto.exists?(ownr: declaracion.ownr, codigo: "confirmacion_hechos")
      Rails.logger.info "[ConfirmarHechosJob] Ya existe. Omitiendo."
      return
    end

    service = ConfirmarHechosService.new(
      declaracion,
      denuncia,
      nombres_anonimizar: nombres_anonimizar,
      tipo_declarante: tipo_declarante,
      nombres_denunciantes: nombres_denunciantes,
      nombres_denunciados: nombres_denunciados
    )
    
    service.generar_reporte!
  rescue => e
    Rails.logger.error "[ConfirmarHechosJob] Error: #{e.message}"
    raise
  end
end