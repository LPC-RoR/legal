# app/mailers/contexts/platform/verification_mailer.rb
class Contexts::Investigations::VrfccnEmailMailer < ApplicationMailer
  def prtcpnt_confirmation(prtcpnt, prtcpnt_id)
    @prtcpnt          = prtcpnt.to_sym
    @rol              = prtcpnt_rol[@prtcpnt]
    @objeto           = prtcpnt_model[@prtcpnt].find(prtcpnt_id)

    if ['invstgdr', 'extrn', 'cntc', 'nmn'].include?(prtcpnt)
      @emprs = @objeto.ownr
    else
      @emprs = @objeto.dnnc.ownr
    end

    if prtcpnt == 'invstgdr'
      @verification_url = verify_invstgdr_url(token: @objeto.verification_token)
    elsif prtcpnt == 'extrn'
      @verification_url = verify_extrn_url(token: @objeto.verification_token)
    elsif prtcpnt == 'cntct'
      @verification_url = verify_app_cntct_url(token: @objeto.verification_token)
      @tarea = tarea_asociada[@objeto.grupo]
    elsif prtcpnt == 'nmn'
      @verification_url = verify_nmn_url(token: @objeto.verification_token)
    elsif prtcpnt == 'dnncnt'
      @verification_url = verify_dnncnt_url(token: @objeto.verification_token)
    elsif prtcpnt == 'dnncd'
      @verification_url = verify_dnncd_url(token: @objeto.verification_token)
    elsif prtcpnt == 'tstg'
      @verification_url = verify_tstg_url(token: @objeto.verification_token)
    end
    @mail_context     = 'investigations'

    if @emprs.logo.present? 
      @head_url         = @emprs.logo.url
    else
      @head_url         = "#{root_url}mssgs/email_head.png"
    end
      @sign_url         = "#{root_url}mssgs/email_sign.png"

    mail(to: @objeto.email, subject: "Confirmación de correo electrónico.")
  end

  private

  def prtcpnt_model
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

  def prtcpnt_rol
    {
      invstgdr: 'investigador',
      extrn:    'empresa externa',
      cntct:    'contacto',
      nmn:      'nómina',
      dnncnt:   'denunciante',
      dnncd:    'denunciado',
      tstg:     'testigo'
    }
  end

  def tarea_asociada
    {
      'RRHH'    => 'Verificación de datos de los participantes y entrega de la documentación asociada a cada uno de ellos',
      'Apt'     => 'Coordinación de la Atención psicológica tempranan para personas denunciantes',
      'Backup'  => 'Respaldo de todos los correos electrónicos enviados desde la plataforma a los participantes e integrantes del equipo de apoyo'
    }
  end
end