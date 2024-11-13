class EmpresasController < ApplicationController
  before_action :authenticate_usuario!, only: %i[ show ]
  before_action :scrty_on
  before_action :set_empresa, only: %i[ show edit update destroy ]
  after_action :add_admin, only: :registro

  include Rut

  # GET /empresas or /empresas.json
  def index
    set_tabla('empresas', Empresa.rut_ordr, true)
  end

  # GET /empresas/1 or /empresas/1.json
  def show
      set_tabla('pro_dtll_ventas', @objeto.pro_dtll_ventas.fecha_ordr, false)
  end

  # GET /empresas/new
  def new
    @objeto = Empresa.new
  end

  def registro
    prms = params[:rgstr]
    unless prms[:rut].blank? or prms[:razon_social].blank? or prms[:email_administrador].blank?
      if valid_rut?(prms[:rut])
        emprs = Empresa.find_by(rut: rut_format(prms[:rut]))
        if emprs.blank?
          @objeto = Empresa.create(rut: rut_format(prms[:rut]), razon_social: prms[:razon_social], email_administrador: prms[:email_administrador])
#          @objeto.app_nominas.create(ownr_type: @objeto.class.name, ownr_id: @objeto.id, nombre: 'Administrador', email: @objeto.email_administrador, tipo:'admin')
          ntc = 'Empresa registrada exitósamente'
        else
          alrt = 'Empresa ya registrada'
        end
      else
        alrt = 'Error de registro: RUT no válido'
      end
    else
      alrt = 'Error de registro: Falta información para completar el registro'
    end

    redirect_to root_path, notice: ntc, alert: alrt
  end

  # GET /empresas/1/edit
  def edit
  end

  # POST /empresas or /empresas.json
  def create
    @objeto = Empresa.new(empresa_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to empresa_url(@objeto), notice: "Empresa was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /empresas/1 or /empresas/1.json
  def update
    respond_to do |format|
      if @objeto.update(empresa_params)
        format.html { redirect_to empresa_url(@objeto), notice: "Empresa was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /empresas/1 or /empresas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to empresas_url, notice: "Empresa was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def add_admin
      unless @objeto.blank?
        @objeto.app_nominas.create(ownr_type: @objeto.class.name, ownr_id: @objeto.id, nombre: 'Administrador', email: @objeto.email_administrador, tipo:'admin')
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_empresa
      @objeto = Empresa.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def empresa_params
      params.require(:empresa).permit(:rut, :razon_social, :email_administrador, :email_verificado, :sha1)
    end
end
