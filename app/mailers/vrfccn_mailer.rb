# app/mailers/vrfccn_mailer.rb
class VrfccnMailer < ApplicationMailer
  layout 'mailer' # o el nombre de tu layout común

  def verification_email(user, verification_url)
    @user = user
    @verification_url = verification_url

    mail(
      to: @user.email,
      from: Rails.application.config.x.mail_from,
      subject: 'Por favor verifica tu correo electrónico'
      )
  end
end