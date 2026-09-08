# app/controllers/concerns/pdf_generatable.rb
module PdfGeneratable
  extend ActiveSupport::Concern

  # ============================================
  # PUNTO DE ENTRADA ÚNICO — SIN CAMBIOS
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
  # GENERAR UN SOLO PDF — SIN CAMBIOS
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
        act_archivo = generar_pdf_sync(reporte, opciones)

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
  # GENERAR PDFs MÚLTIPLES — SIN CAMBIOS
  # ============================================
  def generar_pdf_multiples(reporte, objeto_id:, participantes:, **opciones)
    unless ClssPdf.valid_report?(reporte)
      return render json: { error: "Reporte no válido: #{reporte}" }, status: :bad_request
    end

    act_archivos = participantes.map do |participante|
      generar_pdf_sync(reporte, 
        ownr: participante,
        objeto_id: objeto_id,
        participante: participante,
        **opciones
      )
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

  # ============================================
  # GENERAR EXPEDIENTE ANONIMIZADO
  # ============================================
  def generar_expediente_anonimizado(codes, result_code: 'txt_annm_ntfccns')
    denuncia     = denuncia_actual
    pdf_contents = []
    
    [:krn_denunciantes, :krn_denunciados, :krn_testigos].each do |tipo|
      participantes = denuncia.send(tipo)
      
      participantes.each do |participante|
        codes.each do |code|
          next unless ClssPdf.valid_report?(code)
          
          act_archivos = participante.act_archivos.where(act_archivo: code)
          
          act_archivos.each do |act_original|
            objeto_id = resolver_objeto_id_para_anonimizacion(code, participante, denuncia)
            
            # CORRECCIÓN: genera contenido binario en memoria, sin ActArchivo intermedio
            pdf_content = generar_pdf_contenido(code, 
              ownr: participante,
              objeto_id: objeto_id,
              participante: participante,
              act_original: act_original,
              anonimizar: true,
              **opciones_anonimizacion(participante, denuncia)
            )
            
            pdf_contents << pdf_content if pdf_content.present?
          end
        end
      end
    end
    
    if pdf_contents.empty?
      raise "No se encontraron PDFs para anonimizar"
    end
    
    combined_content = combinar_pdfs_en_memoria(pdf_contents)
    
    result_act = ActArchivo.create!(
      act_archivo: result_code,
      ownr: denuncia,
      nombre: "Expediente Anonimizado - Denuncia #{denuncia.id}"
    )
    
    result_act.pdf.attach(
      io: StringIO.new(combined_content),
      filename: "#{result_code}_#{denuncia.id}_#{Time.current.to_i}.pdf",
      content_type: 'application/pdf'
    )
    
    result_act
  rescue => e
    Rails.logger.error "[PdfGeneratable] Error en anonimización: #{e.message}\n#{e.backtrace.first(5).join("\n")}"
    raise
  end

  private

  # --------------------------------------------
  # Sincronización centralizada (flujo normal)
  # --------------------------------------------
  def generar_pdf_sync(reporte, opciones)
    cntxt_clss    = ClssPdf.context_class(reporte)
    ref_code      = cntxt_clss.ref_code?(reporte)
    objeto_id     = opciones[:objeto_id]
    sync_opciones = opciones.dup

    if objeto_id.present? && cntxt_clss.respond_to?(:datos_para)
      datos = cntxt_clss.datos_para(reporte, objeto_id, sync_opciones)
      sync_opciones[:ownr] = datos[:ownr] if datos[:ownr].present?
    end

    ref = nil
    if ref_code && objeto_id.present?
      ref_clss = cntxt_clss.ref_clss(reporte) 
      ref      = ref_clss.find(objeto_id)
    end
    
    act_archivo = Pdfs::ContextPdfService.generar_pdf(reporte, sync_opciones)

    if ref.present?
      ActReferencia.create!(ref: ref, act_archivo: act_archivo, code: reporte)
    end

    act_archivo
  end

  # --------------------------------------------
  # Generación en memoria (sin almacenar en BD)
  # --------------------------------------------
  def generar_pdf_contenido(reporte, opciones)
    cntxt_clss    = ClssPdf.context_class(reporte)
    objeto_id     = opciones[:objeto_id]
    sync_opciones = opciones.dup

    if objeto_id.present? && cntxt_clss.respond_to?(:datos_para)
      datos = cntxt_clss.datos_para(reporte, objeto_id, sync_opciones)
      sync_opciones[:ownr] = datos[:ownr] if datos[:ownr].present?
    end

    Pdfs::ContextPdfService.generar_pdf_contenido(reporte, sync_opciones)
  end

  # --------------------------------------------
  # Combina contenidos PDF en memoria
  # --------------------------------------------
  def combinar_pdfs_en_memoria(pdf_contents)
    require 'combine_pdf'
    
    combined = CombinePDF.new
    pdf_contents.each do |content|
      combined << CombinePDF.parse(content)
    end
    
    combined.to_pdf
  end

  # --------------------------------------------
  # Resuelve objeto_id según el tipo de reporte
  # --------------------------------------------
  def resolver_objeto_id_para_anonimizacion(code, participante, denuncia)
    case code
    when 'invstgdr'
      if participante.respond_to?(:krn_inv_denuncia) && participante.krn_inv_denuncia.present?
        participante.krn_inv_denuncia.id
      elsif denuncia.respond_to?(:krn_inv_denuncias)
        inv = denuncia.krn_inv_denuncias.find do |i|
          (i.respond_to?(:krn_denunciante_id) && i.krn_denunciante_id == participante.id) ||
          (i.respond_to?(:krn_denunciado_id) && i.krn_denunciado_id == participante.id)
        end
        inv&.id || denuncia.krn_inv_denuncias.first&.id
      else
        participante.id
      end
    when 'txt_mdds_rsgrd', 'txt_mdfccn_mdds_rsgrd', 'txt_mdds_crrctvs_sncns'
      denuncia.id
    else
      participante.id
    end
  end

  def denuncia_actual
    @objeto.is_a?(KrnDenuncia) ? @objeto : @objeto.dnnc
  end

  def opciones_anonimizacion(participante, denuncia)
    todos = (denuncia.krn_denunciantes + denuncia.krn_denunciados + denuncia.krn_testigos).map do |p|
      {
        nombre:    p.try(:nombre).presence || p.try(:display_name).presence,
        cargo:     p.try(:cargo).presence,
        profesion: p.try(:profesion).presence,
        email:     p.try(:email).presence
      }
    end

    {
      nombre_anonimizado:       '[NOMBRE]',
      cargo_anonimizado:        '[CARGO]',
      profesion_anonimizado:    '[PROFESION]',
      email_anonimizado:        '[EMAIL]',
      participante_anonimizado: {
        nombre:    participante.try(:nombre).presence || participante.try(:display_name).presence,
        cargo:     participante.try(:cargo).presence,
        profesion: participante.try(:profesion).presence,
        email:     participante.try(:email).presence
      },
      todos_participantes:      todos
    }
  end

  def generar_pdf_simple(code)
    ownr = @objeto.is_a?(TxtEditable) ? @objeto.ownr : @objeto
    
    if ownr.respond_to?(:ownr) && %w[dclrcn invstgdr].include?(code)
      ownr = ownr.ownr
    end

    generar_pdf(code, ownr: ownr, objeto_id: @objeto.id)
  end

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