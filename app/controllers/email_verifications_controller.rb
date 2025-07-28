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

    if record.email_ok == record.email
      redirect_to root_path, alert: 'Este correo ya fue verificado'
      return
    end

    # Marcar como verificado
#    record.update!(email_ok: true, verification_sent_at: Time.current)
    record.update!(email_ok: record.email, verification_sent_at: Time.current)

    redirect_to root_path, notice: 'Correo electrónico verificado exitosamente'

  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Registro no encontrado'
  rescue => e
    Rails.logger.error "Error verifying email: #{e.message}"
    redirect_to root_path, alert: 'Ocurrió un error al verificar el correo'
  end

  def send_verification
    unless authorized_user?
      redirect_to root_path, alert: 'No autorizado'
      return
    end

    model_type = params[:model_type]
    id = params[:id]

    # Buscar el registro correctamente
    model_class = case model_type
                  when 'denunciante' then KrnDenunciante
                  when 'investigador' then KrnInvestigador
                  when 'denunciado' then KrnDenunciado
                  when 'testigo' then KrnTestigo
                  else nil
                  end

    # Asignar a la variable record
    record = model_class&.find_by(id: id)

    unless record
      redirect_back fallback_location: root_path, alert: 'Registro no encontrado'
      return
    end

    # Actualizar el token
    record.update(verification_token: SecureRandom.urlsafe_base64, n_vrfccn_lnks: record.n_vrfccn_lnks.blank? ? 1 : record.n_vrfccn_lnks += 1, fecha_vrfccn_lnk: Time.zone.now)

    # Generar URL de verificación
    verification_url = verify_custom_email_url(
      token: record.verification_token,
      model_type: model_type,
      host: appropriate_host,
      protocol: appropriate_protocol,
      port: appropriate_port
    )

    Rails.logger.info "Generated verification URL: #{verification_url}"

    if VrfccnMailer.verification_email(record, verification_url).deliver_later
      redirect_back fallback_location: root_path, notice: 'Correo de verificación enviado'
    else
      redirect_back fallback_location: root_path, alert: 'Error al enviar el correo'
    end
  end

  private

  def appropriate_host
    Rails.env.production? ? 'www.laborsafe.cl' : 'localhost'
  end

  def appropriate_protocol
    Rails.env.production? ? 'https' : 'http'
  end

  def appropriate_port
    Rails.env.production? ? nil : 3000
  end

  def authorized_user?
    # Lógica de autorización (ejemplo simple)
    #current_usuario&.admin?
    admin?
  end
end