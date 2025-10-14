class EmpresaMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.empresa_mailer.verification_email.subject
  #
  def verification_email
    empresa = Empresa.find(params[:empresa_id])
    @verification_url = verify_email_url(token: empresa.verification_token)
      
    mail(to: empresa.email_administrador, subject: 'Verifica tu dirección de correo electrónico')
  end

  def wellcome_email(email, password)
    @email    = email
    @password = password
    mail(to: @email, subject: 'Bienvenido a nuestra plataforma')
  end

end
