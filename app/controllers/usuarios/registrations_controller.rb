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
        
        respond_to do |format|
          format.html { redirect_to after_sign_up_path_for(resource) }
          format.turbo_stream { redirect_to after_sign_up_path_for(resource) }
        end
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        
        respond_to do |format|
          format.html { redirect_to after_inactive_sign_up_path_for(resource) }
          format.turbo_stream { render turbo_stream: turbo_stream.redirect_to(after_inactive_sign_up_path_for(resource)) }
        end
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render turbo_stream: turbo_stream.replace('registration_form', partial: 'devise/registrations/form', locals: { resource: resource }) }
      end
    end
  end

  protected

  def after_sign_up_path_for(resource)
    if resource.active_for_authentication?
      root_path # Si el usuario está activo (confirmado)
    else
      # Ruta a la que irán los usuarios no confirmados
      new_user_session_path
    end
  end

  def after_inactive_sign_up_path_for(resource)
    # Mensaje que verán después de registrarse si necesitan confirmación
    # Puedes crear una vista específica para esto en views/devise/registrations/signed_up_but_unconfirmed.html.erb
    signed_up_but_unconfirmed_path
  end

end

