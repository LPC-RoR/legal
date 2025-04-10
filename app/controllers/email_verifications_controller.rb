class EmailVerificationsController < ApplicationController
  def verify
    model_class = params[:model].classify.constantize
    record = model_class.find(params[:id])

    if record.verification_token == params[:token]
      record.verify_email(params[:token])
      redirect_to root_path, notice: "Email verificado correctamente"
    else
      redirect_to root_path, alert: "Token de verificación inválido"
    end
  rescue NameError, ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Error en la verificación"
  end

  def initiate_verification
    model_class = params[:model].classify.constantize
    record = model_class.find(params[:id])
    
    record.generate_verification_token
    record.send_verification_email
    
    redirect_back(
      fallback_location: root_path,
      notice: "Correo de verificación enviado"
    )
  end
end