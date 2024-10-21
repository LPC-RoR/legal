class CuentasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_cuenta, only: %i[  ]

  def ccta
    @objeto = Cliente.find(params[:id])
  end

  def ecta
    @objeto = Empresa.find(params[:id])
  end

  def cdnncs
    @objeto = Cliente.find(params[:id])
    set_tabla('krn_denuncias', @objeto.krn_denuncias, true)
  end

  def ednncs
    @objeto = Empresa.find(params[:id])
    set_tabla('krn_denuncias', @objeto.krn_denuncias, true)
  end

  def cinvstgdrs
    @objeto = Cliente.find(params[:id])
    set_tabla('krn_investigadores', @objeto.krn_investigadores, true)
  end

  def einvstgdrs
    @objeto = Empresa.find(params[:id])
    set_tabla('krn_investigadores', @objeto.krn_investigadores, true)
  end

  def cextrns
    @objeto = Cliente.find(params[:id])
    set_tabla('krn_empresa_externas', @objeto.krn_empresa_externas, true)
  end

  def eextrns
    @objeto = Empresa.find(params[:id])
    set_tabla('krn_empresa_externas', @objeto.krn_empresa_externas, true)
  end

  def ctp_mdds
    @objeto = Cliente.find(params[:id])
    set_tabla('krn_tipo_medidas', @objeto.krn_tipo_medidas, true)
  end

  def etp_mdds
    @objeto = Empresa.find(params[:id])
    set_tabla('krn_tipo_medidas', @objeto.krn_tipo_medidas, true)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cuenta
      @objeto = Cuenta.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cuenta_params
      params.fetch(:cuenta, {})
    end
end
