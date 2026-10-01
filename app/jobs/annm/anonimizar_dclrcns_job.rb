# app/jobs/annm/anonimizar_dclrcns_job.rb
# Paso 1 del flujo de declaraciones:
#   recorre los participantes y crea un TxtEditable 'txt_dclrcn_annmzd'
#   por cada uno que tenga declaración (ownr = participante).
# El paso 2 (PDF combinado 'txt_annm_declaraciones') es síncrono vía
# generar_expediente_anonimizado_dclrcns! (PdfGeneratable).
module Annm
  class AnonimizarDclrcnsJob < ApplicationJob
    queue_as :default

    discard_on ActiveRecord::RecordNotFound do |job, error|
      Rails.logger.error "[Annm::AnonimizarDclrcnsJob] Denuncia no encontrada " \
                         "(job: #{job.job_id}): #{error.message}"
    end

    def perform(krn_denuncia_id)
      denuncia = KrnDenuncia.find(krn_denuncia_id)
      resumen  = denuncia.anonimizar_dclrcns!

      Rails.logger.info "[Annm::AnonimizarDclrcnsJob] Denuncia #{krn_denuncia_id}: " \
        "#{resumen[:creados].size} creadas, #{resumen[:saltados].size} saltadas, " \
        "#{resumen[:sin_declaracion].size} sin declaración"
    end
  end
end