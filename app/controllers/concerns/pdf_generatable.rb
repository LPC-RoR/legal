# app/controllers/concerns/pdf_generatable.rb
module PdfGeneratable
  extend ActiveSupport::Concern

  # Método único para generar PDFs.
  # @param reporte [String] Identificador del reporte (ej: 'doc_honorario')
  # @param ownr [ActiveRecord::Base, nil] Propietario polimórfico del ActArchivo. 
  #   Puede ser nil si el reporte no requiere ownr.
  # @param objeto_id [Integer, String, nil] ID del objeto principal del reporte
  # @param opciones [Hash] Opciones adicionales
  # @option opciones [Boolean] :async Ejecutar en background (default: auto-detect)
  # @option opciones [Boolean] :descargar Responder con redirect a descarga
  # @option opciones [Boolean] :enviar_email Enviar por email tras generar
  # @option opciones [Hash] :datos_extra Datos adicionales para el contexto
  def generar_pdf(reporte, ownr: nil, objeto_id: nil, **opciones)
    objeto_id ||= params[:id]
    
    unless ClssPdf.valid_report?(reporte)
      return render json: { error: "Reporte no válido: #{reporte}" }, status: :bad_request
    end

    opciones.merge!(ownr: ownr, objeto_id: objeto_id)

    if opciones[:async] || async_reporte?(reporte)
      Pdfs::PdfGenerationJob.perform_later(reporte, opciones)
      
      render json: { 
        message: "PDF en proceso de generación", 
        reporte: reporte,
        ownr_type: ownr&.class&.name,
        ownr_id: ownr&.id
      }, status: :accepted
    else
      begin
        act_archivo = Pdfs::ContextPdfService.generar_pdf(reporte, opciones)
        
        if opciones[:descargar]
          redirect_to rails_blob_path(act_archivo.pdf, disposition: 'attachment')
        else
          render json: { 
            act_archivo_id: act_archivo.id,
            pdf_url: url_for(act_archivo.pdf),
            reporte: reporte,
            ownr_type: act_archivo.ownr_type,
            ownr_id: act_archivo.ownr_id
          }
        end
      rescue => e
        Rails.logger.error "[PdfGeneratable] Error generando PDF: #{e.message}"
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end

  private

  def async_reporte?(reporte)
    %w[dnnc st_dclrcns balance_general].include?(reporte.to_s)
  end
end