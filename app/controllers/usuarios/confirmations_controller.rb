# app/controllers/usuarios/confirmations_controller.rb
class Usuarios::ConfirmationsController < Devise::ConfirmationsController

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    
    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      respond_with_navigational(resource) do
        # Forzar redirección HTML tradicional
        redirect_to after_confirmation_path_for(resource_name, resource), allow_other_host: true
      end
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity) do
        redirect_to new_usuario_confirmation_path, allow_other_host: true
      end
    end
  end

  protected

  def after_confirmation_path_for(resource_name, resource)
    # Cambia esto por tu ruta preferida después de confirmación
    new_usuario_session_path(confirmation: 'success')
  end
end