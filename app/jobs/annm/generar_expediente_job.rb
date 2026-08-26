# app/jobs/annm/generar_expediente_job.rb
module Annm
  class GenerarExpedienteJob < ApplicationJob
    queue_as :default

    def perform(denuncia_id, grupo)
      denuncia = KrnDenuncia.find(denuncia_id)

      Rails.logger.info "[Annm::GenerarExpedienteJob] Denuncia #{denuncia_id} | Grupo '#{grupo}' | Iniciando..."

      txt_editable = denuncia.generar_expediente_anonimizado!(grupo)

      if txt_editable
        Rails.logger.info "[Annm::GenerarExpedienteJob] Completado. TxtEditable id=#{txt_editable.id}, código=#{txt_editable.codigo}"
      else
        Rails.logger.warn "[Annm::GenerarExpedienteJob] Sin resultado para grupo '#{grupo}'"
      end
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error "[Annm::GenerarExpedienteJob] Denuncia #{denuncia_id} no encontrada"
    rescue => e
      Rails.logger.error "[Annm::GenerarExpedienteJob] Error: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.first(10).join("\n")
      raise
    end
  end
end