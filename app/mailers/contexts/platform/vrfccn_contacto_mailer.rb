# app/mailers/contexts/platform/verification_mailer.rb
class Contexts::Platform::VrfccnContactoMailer < ApplicationMailer
  def contacto_confirmation(contacto_id)
    @contacto         = ComRequerimiento.find(contacto_id)
    @verification_url = verify_cntct_url(token: @contacto.verification_token)
    @mail_context = 'platform'
    @head_url = "#{root_url}mssgs/email_head.png"
    @sign_url = "#{root_url}mssgs/email_sign.png"

    mail(to: @contacto.email, subject: "Confirmación de correo electrónico.")
  end

end