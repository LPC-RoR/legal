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

    # Verificar si ya hay un job en ejecución para esta denuncia
    if job_en_ejecucion?(@objeto.id)
      redirect_to "/krn_denuncias/#{@objeto.id}_1", 
        alert: 'La generación de documentos ya está en proceso. Por favor espere.'
      return
    end

    # Marcar que hay un job en ejecución (expira en 10 minutos)
    marcar_job_en_ejecucion(@objeto.id)
    
    Mailers::PdfGenerationAndDeliveryJob.perform_later(@objeto.id, rprt, nid)
    
    redirect_to "/krn_denuncias/#{@objeto.id}_1", 
      notice: 'Generación de documentos iniciada. Los PDFs se procesarán en segundo plano.'
  end

  private

  def job_en_ejecucion?(denuncia_id)
    Rails.cache.exist?("pdf_generation:#{denuncia_id}")
  end

  def marcar_job_en_ejecucion(denuncia_id)
    Rails.cache.write("pdf_generation:#{denuncia_id}", true, expires_in: 10.minutes)
  end

  def desmarcar_job_en_ejecucion(denuncia_id)
    Rails.cache.delete("pdf_generation:#{denuncia_id}")
  end
  
end