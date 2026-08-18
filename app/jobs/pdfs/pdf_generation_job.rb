# app/jobs/pdfs/pdf_generation_job.rb
module Pdfs
  class PdfGenerationJob < ApplicationJob
    queue_as :pdf_generation

    # @param reporte [String] Identificador del reporte
    # @param opciones [Hash] Incluye :ownr (ya deserializado por ActiveJob), :objeto_id, etc.
    def perform(reporte, opciones = {})
      return unless ClssPdf.valid_report?(reporte)

      ownr      = opciones.delete('ownr') || opciones.delete(:ownr)
      objeto_id = opciones.delete('objeto_id') || opciones.delete(:objeto_id)
      
      opciones.merge!(ownr: ownr, objeto_id: objeto_id)

      # Lock distribuido para evitar que dos workers generen el mismo PDF simultáneamente
      # (no es deduplicación, es prevención de race condition)
      lock_key = "pdf_generando:#{reporte}:#{ownr&.class&.name}:#{ownr&.id}:#{Date.current}:#{Time.current.to_i}"
      
      unless Rails.cache.write(lock_key, true, expires_in: 5.minutes, unless_exist: true)
        Rails.logger.warn "[PdfGenerationJob] Ya en proceso: #{reporte} para #{ownr&.class&.name}##{ownr&.id}"
        return
      end

      act_archivo = ContextPdfService.generar_pdf(reporte, opciones)

      # Si se pidió envío de email (legacy o casos especiales), se maneja aquí
      # Pero para documentos legales, usar ActArchivo#enviar_pdf_por_email sincrónicamente
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

    def enviar_email!(act_archivo, opciones)
      # Implementar según tu PdfDeliveryService existente
      # Nota: para documentos legales, preferir ActArchivo#enviar_pdf_por_email
    end
  end
end