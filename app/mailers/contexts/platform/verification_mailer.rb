# app/mailers/contexts/platform/verification_mailer.rb
class Contexts::Platform::VerificationMailer < ApplicationMailer
  def empresa_confirmation(empresa_id)
    @empresa = Empresa.find(empresa_id)
    @verification_url = verify_email_url(token: @empresa.verification_token)
    @tenant = @empresa.tenant # has_one :tenant, as: :owner
    @mail_context = 'platform'
    @head_url = "#{root_url}mssgs/email_head.png"
    @sign_url = "#{root_url}mssgs/email_sign.png"

    mail(to: @empresa.email_administrador, subject: "Confirmación de cuenta")
  end

end