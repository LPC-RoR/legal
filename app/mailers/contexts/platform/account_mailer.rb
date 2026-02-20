# app/mailers/contexts/platform/account_mailer.rb
module Contexts
  module Platform
    class AccountMailer < BaseMailer
      def welcome_email(usuario_id, random_password)
        @usuario = Usuario.find(usuario_id)
        @email = @usuario.email
        @password = random_password
        @login_url = new_usuario_session_url
        @mail_context = 'platform'
        @head_url = "#{root_url}mssgs/email_head.png"
        @sign_url = "#{root_url}mssgs/email_sign.png"        

        mail to: @usuario.email, subject: "Bienvenido a Laborsafe"
      end

    end
  end
end