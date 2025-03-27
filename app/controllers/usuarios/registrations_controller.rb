class Usuarios::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :turbo_stream

  protected

  def after_inactive_sign_up_path_for(resource)
    # Ruta a donde redirigir después del registro inactivo (esperando confirmación)
    new_usuario_session_path
  end
end