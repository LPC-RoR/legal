module AgeUsr
  extend ActiveSupport::Concern

  def dssgn_usr
    prtcpnt = AgeUsuario.find(params[:oid])
    @objeto.age_usuarios.delete(prtcpnt)

    get_rdrccn
    redirect_to @rdrccn
  end

  def assgn_usr
    prtcpnt = AgeUsuario.find(params[:oid])
    @objeto.age_usuarios << prtcpnt

    get_rdrccn
    redirect_to @rdrccn
  end

end