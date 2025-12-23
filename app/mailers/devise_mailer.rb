class DeviseMailer < Devise::Mailer
  layout 'mailer_devise' # CORRECTO - no lo quites
  
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  # Adjuntar imágenes automáticamente antes de cada email
  before_action :add_inline_attachments!

  def confirmation_instructions(record, token, opts={})
    opts[:subject] = "Confirma tu cuenta en ADDT"
    super
  end

  def reset_password_instructions(record, token, opts={})
    opts[:subject] = "Restablece tu contraseña en ADDT"
    super
  end

  private

  def add_inline_attachments!
    attach_image('email_head.png')
    attach_image('email_sign.webp')
  end

  def attach_image(filename)
    path = Rails.root.join('app/assets/images/mssgs', filename)
    attachments.inline[filename] = File.read(path) if File.exist?(path)
  rescue => e
    Rails.logger.warn "No se pudo adjuntar #{filename}: #{e.message}"
  end
end