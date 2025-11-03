module AgeUsr
  extend ActiveSupport::Concern

  def dssgn_usr
    usr = Usuario.find(params[:oid])
    @objeto.responsables.delete(usr)

    redirect_to(request.referer || root_path)
  end

  def assgn_usr
    usr = Usuario.find(params[:oid])
    @objeto.responsables << usr

    redirect_to(request.referer || root_path)
  end

end