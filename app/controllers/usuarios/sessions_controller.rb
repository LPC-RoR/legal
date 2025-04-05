class Usuarios::SessionsController < Devise::SessionsController
  respond_to :html, :turbo_stream

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    
    respond_to do |format|
      format.html { redirect_to after_sign_in_path_for(resource) }
      format.turbo_stream { redirect_to after_sign_in_path_for(resource), status: :see_other }
    end
  end

  private

  def respond_to_on_destroy
    respond_to do |format|
      format.html { redirect_to after_sign_out_path_for(resource_name) }
      format.turbo_stream { redirect_to after_sign_out_path_for(resource_name), status: :see_other }
    end
  end
end