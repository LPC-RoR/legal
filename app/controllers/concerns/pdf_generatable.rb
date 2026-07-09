# app/controllers/concerns/pdf_generatable.rb
module PdfGeneratable
  extend ActiveSupport::Concern

  # Método único para generar PDFs.
  # @param reporte [String] Identificador del reporte (ej: 'txt_mdds_crrctvs_sncns')
  # @param ownr [ActiveRecord::Base, nil] Propietario polimórfico del ActArchivo
  # @param objeto_id [Integer, String, nil] ID del objeto principal del reporte
  # @param opciones [Hash] Opciones adicionales
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
        render json: { error: e.message }, status: :unprocessable_content
      end
    end
  end

  # ============================================
  # GENERAR PDFs MÚLTIPLES (uno por participante)
  # ============================================
  # @param reporte [String] Código del reporte
  # @param objeto_id [Integer] ID del objeto principal (TxtEditable)
  # @param participantes [Array] Colección de participantes
  # @param opciones [Hash] Opciones adicionales
  def generar_pdf_multiples(reporte, objeto_id:, participantes:, **opciones)
    unless ClssPdf.valid_report?(reporte)
      return render json: { error: "Reporte no válido: #{reporte}" }, status: :bad_request
    end

    cntxt_clss  = ClssPdf.context_class(reporte)
    ref_code    = cntxt_clss.ref_code?(reporte)

    if ref_code
      ref_clss    = cntxt_clss.ref_clss(reporte) 
      # Obtener el ref que está llamando a este método
      ref = ref_clss.find(objeto_id)
    end

    act_archivos = participantes.map do |participante|
      # Generar el PDF para cada participante
      act_archivo = Pdfs::ContextPdfService.generar_pdf(reporte, 
        ownr: participante,
        objeto_id: objeto_id,
        participante: participante,
        **opciones
      )

      if ref_code
        # Crear la referencia polimórfica entre TxtEditable y ActArchivo
        ActReferencia.create!(
          ref: ref,        # Polimórfico: guarda ref_type = "TxtEditable", ref_id = ref.id
          act_archivo: act_archivo
        )
      end

      act_archivo
    end

    render json: {
      message: "PDFs generados exitosamente",
      reporte: reporte,
      cantidad: act_archivos.length,
      act_archivos: act_archivos.map { |a| { 
        id: a.id, 
        nombre: a.nombre,
        ownr_type: a.ownr_type,
        ownr_id: a.ownr_id
      }}
    }
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "[PdfGeneratable] TxtEditable no encontrado: #{e.message}"
    render json: { error: "TxtEditable no encontrado" }, status: :not_found
  rescue => e
    Rails.logger.error "[PdfGeneratable] Error generando PDFs múltiples: #{e.message}"
    render json: { error: e.message }, status: :unprocessable_content
  end

  private

  def async_reporte?(reporte)
    %w[dnnc st_dclrcns balance_general].include?(reporte.to_s)
  end
end