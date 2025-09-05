class CuentasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_cuenta, only: %i[ dnncs invstgdrs extrns nmn ]

  def dnncs
      set_tab(:indx, ['Denuncias', 'Investigadores', 'Empresas externar', 'Nómina']) if admin?
      set_tabla('krn_denuncias', @objeto.krn_denuncias.ordr, true)
  end

  def invstgdrs
      set_tab(:indx, ['Denuncias', 'Investigadores', 'Empresas externar', 'Nómina']) if admin?
      set_tabla('krn_investigadores', @objeto.krn_investigadores, true)
  end

  def extrns
      set_tab(:indx, ['Denuncias', 'Investigadores', 'Empresas externar', 'Nómina']) if admin?
      set_tabla('krn_empresa_externas', @objeto.krn_empresa_externas, true)
  end

  def nmn
      set_tab(:indx, ['Denuncias', 'Investigadores', 'Empresas externar', 'Nómina']) if admin?
      set_tabla('app_nominas', @objeto.app_nominas, true)
      set_tabla('app_contactos', @objeto.app_contactos.order(:nombre), true)
  end

  def ctp_mdds
    unless (scp_err? or (scp_activo? and (scp_activo.id != params[:id].to_i)))
      @objeto = Cliente.find(params[:id])
      set_tabla('krn_tipo_medidas', @objeto.krn_tipo_medidas, true)
    else
      redirect_to root_path, alert: 'Usuario redireccionado: no tiene acceso a la página que llamó.'
    end
  end

  def etp_mdds
    unless (scp_err? or (scp_activo? and (scp_activo.id != params[:id].to_i)))
      @objeto = Empresa.find(params[:id])
      set_tabla('krn_tipo_medidas', @objeto.krn_tipo_medidas, true)
    else
      redirect_to root_path, alert: 'Usuario redireccionado: no tiene acceso a la página que llamó.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cuenta
      prms = params[:id].split('_')
      @mdl = prms[0] == 'e' ? Empresa : Cliente
      @objeto = @mdl.find(prms[1])
    end

    # Only allow a list of trusted parameters through.
    def cuenta_params
      params.fetch(:cuenta, {})
    end
end