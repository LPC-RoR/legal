# app/controllers/email_verifications_controller.rb
class EmailVerificationsController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on

  def verify
    token = params[:token]
    model_type = params[:model_type]

    model_class = case model_type
                  when 'denunciante' then KrnDenunciante
                  when 'investigador' then KrnInvestigador
                  when 'denunciado' then KrnDenunciado
                  when 'testigo' then KrnTestigo
                  else nil
                  end

    if model_class.nil?
      redirect_to root_path, alert: 'Tipo de modelo no válido'
      return
    end

    record = model_class.find_by(verification_token: token)

    if record && record.verification_sent_at.nil?
      record.update(verification_sent_at: Time.current)
      redirect_to root_path, notice: 'Correo electrónico verificado exitosamente'
    elsif record&.verification_sent_at.present?
      redirect_to root_path, alert: 'Este enlace ya fue utilizado'
    else
      redirect_to root_path, alert: 'Enlace de verificación no válido'
    end
  end

  def send_verification
    # Asegurar que solo usuarios autorizados puedan reenviar
    unless authorized_user?
      redirect_to root_path, alert: 'No autorizado'
      return
    end

    model_type = params[:model_type]
    id = params[:id]

    model_class = case model_type
                  when 'denunciante' then KrnDenunciante
                  when 'investigador' then KrnInvestigador
                  when 'denunciado' then KrnDenunciado
                  when 'testigo' then KrnTestigo
                  else nil
                  end

    record = model_class&.find_by(id: id)

    unless record
      redirect_back fallback_location: root_path, alert: 'Registro no encontrado'
      return
    end

    record.update(verification_token: SecureRandom.urlsafe_base64)

    verification_url = verify_custom_email_url(
      token: record.verification_token,
      model_type: model_type,
      host: Rails.application.config.action_mailer.default_url_options[:host],
      protocol: Rails.application.config.action_mailer.default_url_options[:protocol] || 'https'
    )

    if VrfccnMailer.verification_email(record, verification_url).deliver_later
      redirect_back fallback_location: root_path, notice: 'Correo de verificación enviado'
    else
      redirect_back fallback_location: root_path, alert: 'Error al enviar el correo'
    end
  end

  private

  def authorized_user?
    # Implementa tu lógica de autorización aquí
    # Ejemplo simple:
    admin?
  end
end