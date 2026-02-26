module MailDesk
  extend ActiveSupport::Concern

  def set_vrfccn_fields
    # Actualizar token y contadores (misma lógica que en create)
    @objeto.verification_token    = SecureRandom.urlsafe_base64
    @objeto.n_vrfccn_lnks         = (@objeto.n_vrfccn_lnks || 0) + 1
    @objeto.fecha_vrfccn_lnk      = Time.zone.now
    @objeto.verification_sent_at  = Time.current
  end

  # Extraer el envío de correo a un método privado para reutilizar
  ## key: {'tstg', 'dnncnt', etc}
  ## objeto: objeto de la clase relacioanda con key
  def enviar_correo_verificacion(key)
    Contexts::Investigations::VrfccnEmailMailer
      .prtcpnt_confirmation(key, @objeto.id)
      .deliver_later
  end

  # NUEVA ACCIÓN: Reenviar correo de verificación
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

  # Usando el sym propio del modelo, entrega el modelo
  def mdl_sym_to_mld
    {
      invstgdr: KrnInvestigador,
      extrn:    KrnEmpresaExterna,
      cntct:    AppContacto,
      nmn:      AppNomina,
      dnncnt:   KrnDenunciante,
      dnncd:    KrnDenunciado,
      tstg:     KrnTestigo
    }
  end

end