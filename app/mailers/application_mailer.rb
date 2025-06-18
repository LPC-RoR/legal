class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@laborsafe.cl'
  layout 'mailer'

  before_action :add_logo_attachment
  before_action :add_signature_attachment

  private

  def add_logo_attachment
    attachments.inline['email_head.png'] = File.read(Rails.root.join('app/assets/images/email_head.png'))
  end

  def add_signature_attachment
    attachments.inline['email_sign.png'] = File.read(Rails.root.join('app/assets/images/email_sign.png'))
  end

end
