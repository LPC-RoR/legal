# app/controllers/email_verifications_controller.rb
class EmailVerificationsController < ApplicationController
  before_action :authenticate_usuario!, except: [:verify]
  before_action :scrty_on, except: [:verify]

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

    unless model_class
      redirect_to root_path, alert: 'Tipo de modelo no válido'
      return
    end

    record = model_class.find_by(verification_token: token)

    unless record
      redirect_to root_path, alert: 'Enlace de verificación no válido'
      return
    end

    # Verificar si el token ya fue usado (opcional)
#    if record.email_verified?
    # Cambie para que usara el campo ya existente email_ok
    if record.email_ok?
      redirect_to root_path, alert: 'Este correo ya fue verificado'
      return
    end

    # Marcar como verificado
    record.update!(email_ok: true, verification_sent_at: Time.current)

    redirect_to root_path, notice: 'Correo electrónico verificado exitosamente'
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

#    verification_url = verify_custom_email_url(
#      token: record.verification_token,
#      model_type: model_type,
#      host: Rails.application.config.action_mailer.default_url_options[:host],
#      protocol: Rails.application.config.action_mailer.default_url_options[:protocol] || 'https'
#    )

    verification_url = url_for(
      controller: 'email_verifications',
      action: 'verify',
      token: record.verification_token,
      model_type: model_type,
      only_path: false,
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