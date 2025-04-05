class Usuarios::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :turbo_stream

  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?

    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        
        respond_to do |format|
          format.html { redirect_to after_inactive_sign_up_path_for(resource) }
          format.turbo_stream { render turbo_stream: turbo_stream.action(:redirect, after_inactive_sign_up_path_for(resource)) }
        end
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    new_usuario_session_path
  end

  def after_sign_up_path_for(resource)
    root_path
  end
end