# config/initializers/devise_turbo_fix.rb
module DeviseTurboFix
  extend ActiveSupport::Concern

  included do
    before_action :configure_permitted_parameters, if: :devise_controller?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

#  def respond_with(resource, _opts = {})
#    if resource.persisted?
#      redirect_to after_sign_in_path_for(resource)
#    else
#      super
#    end
#  end

  def respond_with(resource, *args)
    return super unless request.format.docx? # Skip Turbo for .docx requests
    super
  end

end