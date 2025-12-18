# app/controllers/usuarios/registrations_controller.rb
module Usuarios
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_account_update_params, only: [:update]
    respond_to :html, :turbo_stream

    def create
      email = sign_up_params[:email]&.downcase

      # 1. ¿Está en nómina?
      nomina = AppNomina.find_by(email: email)

      # Dog NO requiere nómina, en versión anterior se pedía nómina bajo AppVersión. No tiene sentido tener información protegida en un registro
      unless nomina or email == Rails.application.credentials[:dog][:email]
        build_resource(sign_up_params)
        resource.errors.add(:email, 'no está autorizado para registrarse')
        respond_with_navigational(resource) { render :new }
        return
      end

      # Dog no tiene nomina -> no tiene ownr
      if nomina
        # 2. Tenant (crear si no existe)
        owner = nomina&.ownr
        if owner
          if owner.tenant.nil?
            tenant = owner.build_tenant(nombre: owner.try(:razon_social) || owner.try(:nombre) || 'Tenant')
            tenant.save!
          else
            tenant = owner.tenant
          end
        else
          tenant = nil
        end
      end

      # 4. Crear usuario
      build_resource(sign_up_params)
      resource.tenant = tenant

      if resource.save
        resource.add_role(:user, tenant) # rol inicial
        yield resource if block_given?

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
      resource.active_for_authentication? ? root_path : new_user_session_path
    end

    def after_inactive_sign_up_path_for(resource)
      signed_up_but_unconfirmed_path
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:nombre])
    end

    def respond_with(resource, _opts = {})
      if request.format.turbo_stream?
        if resource.errors.empty?
          redirect_to after_update_path_for(resource)
        else
          render :edit, status: :unprocessable_entity
        end
      else
        super
      end
    end
  end
end