class EmpresaMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.empresa_mailer.verification_email.subject
  #
  def verification_email(objeto)
    @objeto = objeto
    @verification_url = verify_email_url(token: @objeto.verification_token)
    
    mail(to: @objeto.email_administrador, subject: 'Verifica tu dirección de correo electrónico')
  end
end
