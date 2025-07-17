module AgeUsr
  extend ActiveSupport::Concern

  def dssgn_usr
    prtcpnt = AgeUsuario.find(params[:oid])
    @objeto.age_usuarios.delete(prtcpnt)

    redirect_to(request.referer || root_path)
  end

  def assgn_usr
    prtcpnt = AgeUsuario.find(params[:oid])
    @objeto.age_usuarios << prtcpnt

    redirect_to(request.referer || root_path)
  end

end