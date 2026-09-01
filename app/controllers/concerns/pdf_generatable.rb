# app/controllers/concerns/pdf_generatable.rb
module PdfGeneratable
  extend ActiveSupport::Concern

  # ============================================
  # PUNTO DE ENTRADA ÚNICO — la vista solo pasa 'code'
  # ============================================
  def cargar_pdf
    code = params[:code]
    
    unless code.present? && ClssPdf.valid_report?(code)
      return render json: { error: "Reporte no válido" }, status: :bad_request
    end

    cntxt_clss = ClssPdf.context_class(code)
    
    if cntxt_clss.has_one?(code)
      generar_pdf_simple(code)
    else
      generar_pdf_multiples_desde_cargar(code)
    end
  end

  # ============================================
  # GENERAR UN SOLO PDF (puede ser sync o async)
  # ============================================
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
        cntxt_clss  = ClssPdf.context_class(reporte)
        ref_code    = cntxt_clss.ref_code?(reporte)

        # Corrección de ownr para reportes que deben tener al participante, no al registro intermedio
        if cntxt_clss.respond_to?(:datos_para)
          datos = cntxt_clss.datos_para(reporte, objeto_id, opciones)
          opciones[:ownr] = datos[:ownr] if datos[:ownr].present?
        end

        if ref_code
          ref_clss = cntxt_clss.ref_clss(reporte) 
          ref      = ref_clss.find(objeto_id)
        end
        
        act_archivo = Pdfs::ContextPdfService.generar_pdf(reporte, opciones)

        if ref_code
          ActReferencia.create!(ref: ref, act_archivo: act_archivo, code: reporte)
        end

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
  def generar_pdf_multiples(reporte, objeto_id:, participantes:, **opciones)
    unless ClssPdf.valid_report?(reporte)
      return render json: { error: "Reporte no válido: #{reporte}" }, status: :bad_request
    end

    cntxt_clss  = ClssPdf.context_class(reporte)
    ref_code    = cntxt_clss.ref_code?(reporte)

    if ref_code
      ref_clss = cntxt_clss.ref_clss(reporte) 
      ref      = ref_clss.find(objeto_id)
    end

    act_archivos = participantes.map do |participante|
      act_archivo = Pdfs::ContextPdfService.generar_pdf(reporte, 
        ownr: participante,
        objeto_id: objeto_id,
        participante: participante,
        **opciones
      )

      if ref_code
        ActReferencia.create!(ref: ref, act_archivo: act_archivo, code: reporte)
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
    Rails.logger.error "[PdfGeneratable] #{e.message}"
    render json: { error: "Registro no encontrado" }, status: :not_found
  rescue => e
    Rails.logger.error "[PdfGeneratable] Error generando PDFs múltiples: #{e.message}"
    render json: { error: e.message }, status: :unprocessable_content
  end

  private

  # --------------------------------------------
  # Un solo PDF (has_one)
  # --------------------------------------------
  def generar_pdf_simple(code)
    ownr = @objeto.is_a?(TxtEditable) ? @objeto.ownr : @objeto
    
    # Corrección de ownr para reportes que deben tener al participante
    if ownr.respond_to?(:ownr) && %w[dclrcn invstgdr].include?(code)
      ownr = ownr.ownr
    end

    generar_pdf(code, ownr: ownr, objeto_id: @objeto.id)
  end

  # --------------------------------------------
  # Múltiples PDFs (uno por participante)
  # --------------------------------------------
  def generar_pdf_multiples_desde_cargar(code)
    dnnc = @objeto.is_a?(KrnInvDenuncia) ? @objeto.krn_denuncia : @objeto.dnnc
    
    participantes = case code
    when 'crdncn_apt'
      dnnc.ownr.app_contactos.where(grupo: 'Apt')
    when 'dts_prncpls', 'dts_tstgs'
      dnnc.ownr.app_contactos.where(grupo: 'RRHH')
    when 'dnncnt_info_oblgtr', 'comprobante'
      dnnc.krn_denunciantes
    when 'txt_dclrcn_dnncd'
      dnnc.krn_denunciados
    when 'txt_tstg'
      dnnc.krn_testigos
    else
      dnnc.krn_denunciantes + dnnc.krn_denunciados
    end

    if participantes.empty?
      return render json: { error: "No hay participantes" }, status: :unprocessable_content
    end

    generar_pdf_multiples(code, 
      dnnc_id: dnnc.id,
      objeto_id: @objeto.id,
      participantes: participantes,
      async: false
    )
  end

  def async_reporte?(reporte)
    true
  end
end