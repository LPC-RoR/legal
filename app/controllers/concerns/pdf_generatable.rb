# app/controllers/concerns/pdf_generatable.rb
module PdfGeneratable
  extend ActiveSupport::Concern

  # ============================================
  # ÚNICO PUNTO DE ENTRADA — la vista solo pasa 'code'
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
      generar_pdf_multiples(code)
    end
  end

  private

  # --------------------------------------------
  # Un solo PDF (has_one)
  # --------------------------------------------
  def generar_pdf_simple(code)
    ownr = @objeto.is_a?(TxtEditable) ? @objeto.ownr : @objeto
    
    # Corrección de ownr para 'dclrcn' y similares
    if ownr.respond_to?(:ownr) && %w[dclrcn txt_dclrcn txt_dclrcn_annmzd txt_dclrcn_rsmn].include?(code)
      ownr = ownr.ownr
    end

    generar_pdf(code, ownr: ownr, objeto_id: @objeto.id)
  end

  # --------------------------------------------
  # Múltiples PDFs (uno por participante)
  # --------------------------------------------
  def generar_pdf_multiples(code)
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

    super(code, 
      dnnc_id: dnnc.id,
      objeto_id: @objeto.id,
      participantes: participantes,
      async: false
    )
  end
end