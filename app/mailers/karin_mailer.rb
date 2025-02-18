class KarinMailer < ApplicationMailer
  default from: 'no-reply@tudominio.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://tudominio.com/login'
    mail(to: @user.email, subject: 'Bienvenido a Nuestra Aplicación')
  end
end
