class DeviseMailer < Devise::Mailer
  layout 'mailer_devise' # usa app/views/layouts/mailer.html.erb
  #default template_path: 'layouts/mailer:devise'

  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def confirmation_instructions(record, token, opts={})
    # Personalizar el asunto
    opts[:subject] = "Confirma tu cuenta en ADDT"
    attachments.inline['email_head.png'] = File.read(Rails.root.join('app/assets/images/email_head.png'))
    attachments.inline['email_sign.png'] = File.read(Rails.root.join('app/assets/images/email_sign.png'))
    super
  end

  def reset_password_instructions(record, token, opts={})
    opts[:subject] = "Restablece tu contraseña en ADDT"
    attachments.inline['email_head.png'] = File.read(Rails.root.join('app/assets/images/email_head.png'))
    attachments.inline['email_sign.png'] = File.read(Rails.root.join('app/assets/images/email_sign.png'))
    super
  end
  
  # Puedes añadir más métodos para otros tipos de correos

end