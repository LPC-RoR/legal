module MailDesk
  extend ActiveSupport::Concern

  def set_vrfccn_fields
    @objeto.verification_token    = SecureRandom.urlsafe_base64
    @objeto.n_vrfccn_lnks         = (@objeto.n_vrfccn_lnks || 0) + 1
    @objeto.fecha_vrfccn_lnk      = Time.zone.now
    @objeto.verification_sent_at  = Time.current
  end

  def enviar_correo_verificacion(key)
    Contexts::Investigations::VrfccnEmailMailer
      .prtcpnt_confirmation(key, @objeto.id)
      .deliver_later
  end

  def reenviar_correo
    @objeto = mdl_sym_to_mld[params[:key].to_sym].find(params[:id])
    
    set_vrfccn_fields
    
    respond_to do |format|
      if @objeto.save
        enviar_correo_verificacion(params[:key])
        
        format.html { redirect_to default_redirect_path(@objeto), notice: "Correo de verificación reenviado exitosamente." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { redirect_to default_redirect_path(@objeto), alert: "No se pudo reenviar el correo." }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def mdl_sym_to_mld
    {
      invstgdr: KrnInvestigador,
      drvcn:    KrnDerivacion,
      extrn:    KrnEmpresaExterna,
      cntct:    AppContacto,
      nmn:      AppNomina,
      dnncnt:   KrnDenunciante,
      dnncd:    KrnDenunciado,
      tstg:     KrnTestigo
    }
  end

  def krn_pdf_rprt
    rprt  = params[:rprt]
    nid   = params[:nid]

    Mailers::PdfGenerationAndDeliveryJob.perform_later(@objeto.id, rprt, nid)

    shw_tab_id = ClssPdfRprt.rcrs_rprt?(rprt) ? '3' : (['declaracion', 'txt_dclrcn'].include?(rprt) ? '2' : '1')
    
    redirect_to "/krn_denuncias/#{@objeto.id}_#{shw_tab_id}", 
      notice: 'Generación de documentos iniciada. Los PDFs se procesarán en segundo plano.'
  end

end