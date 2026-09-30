# app/jobs/annm/anonimizar_dclrcns_job.rb
module Annm
  class AnonimizarDclrcnsJob < ApplicationJob
    queue_as :default

    # Retry estándar de ActiveJob/Sidekiq para errores transitorios
    # (LLM, red, etc.). RecordNotFound se descarta: la denuncia ya no existe.
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