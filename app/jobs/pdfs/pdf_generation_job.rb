# app/jobs/pdfs/pdf_generation_job.rb
module Pdfs
  class PdfGenerationJob < ApplicationJob
    queue_as :pdf_generation

    # @param reporte [String] Identificador del reporte
    # @param opciones [Hash] Incluye :ownr (serializable), :objeto_id, etc.
    def perform(reporte, opciones = {})
      return unless ClssPdf.valid_report?(reporte)

      ownr = deserializar_ownr(opciones.delete('ownr') || opciones.delete(:ownr))
      objeto_id = opciones.delete('objeto_id') || opciones.delete(:objeto_id)
      
      opciones.merge!(ownr: ownr, objeto_id: objeto_id)

      # Lock distribuido por reporte + ownr + fecha
      lock_key = "pdf_generation:#{reporte}:#{ownr&.class&.name}:#{ownr&.id}:#{Date.current}"
      
      unless Rails.cache.write(lock_key, true, expires_in: 30.minutes, unless_exist: true)
        Rails.logger.warn "[PdfGenerationJob] Bloqueado: #{lock_key}"
        return
      end

      # Deduplicación diaria
      cache_key = "pdf_generado:#{reporte}:#{ownr&.class&.name}:#{ownr&.id}:#{Date.current}"
      
      if !exento_deduplicacion?(reporte) && Rails.cache.exist?(cache_key)
        Rails.logger.info "[PdfGenerationJob] Ya generado hoy: #{cache_key}"
        Rails.cache.delete(lock_key)
        return
      end

      act_archivo = ContextPdfService.generar_pdf(reporte, opciones)

      Rails.cache.write(cache_key, act_archivo.id, expires_in: 24.hours) unless exento_deduplicacion?(reporte)

      if opciones['enviar_email'] || opciones[:enviar_email]
        enviar_email!(act_archivo, opciones)
      end

      act_archivo

    rescue => e
      Rails.logger.error "[PdfGenerationJob] Error: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.first(10).join("\n")
      raise
    ensure
      Rails.cache.delete(lock_key) if defined?(lock_key) && lock_key.present?
    end

    private

    # Serializa ownr para pasar al job (GlobalID)
    def self.serialize_ownr(ownr)
      return nil if ownr.nil?
      ownr.to_global_id.to_s
    end

    # Deserializa ownr desde el job
    def deserializar_ownr(gid)
      return nil if gid.nil?
      GlobalID::Locator.locate(gid)
    rescue => e
      Rails.logger.error "[PdfGenerationJob] Error deserializando ownr: #{e.message}"
      nil
    end

    def exento_deduplicacion?(reporte)
      %w[doc_honorario].include?(reporte.to_s)
    end

    def enviar_email!(act_archivo, opciones)
      # Implementar según tu PdfDeliveryService existente
    end
  end
end