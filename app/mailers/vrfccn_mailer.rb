class VrfccnMailer < ActionMailer::Base
  def verification_email(model_class, model_id)
    record = model_class.constantize.find(model_id)
    @record = record
    @model_name = record.class.model_name.human
    @verification_url = url_for(
      controller: 'email_verifications',
      action: 'verify',
      model: record.class.name.underscore,
      id: record.id,
      token: record.verification_token,
      only_path: false
    )

    mail(
      to: record.email,
      subject: "Verifica tu dirección de correo (#{@model_name})"
    )
  end
end