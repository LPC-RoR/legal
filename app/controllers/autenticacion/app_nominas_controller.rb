class Autenticacion::AppNominasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :inicia_sesion
  before_action :set_app_nomina, only: %i[ show edit update destroy ]

  # GET /app_nominas or /app_nominas.json
  def index
    set_tabla('app_nominas', AppNomina.gnrl.nombre_ordr, false)
  end

  # GET /app_nominas/1 or /app_nominas/1.json
  def show
  end

  # GET /app_nominas/new
  def new
    oid = params[:oid].blank? ? nil : params[:oid]
    oclss = params[:oid].blank? ? nil : params[:oclss]
    @objeto = AppNomina.new(ownr_type: oclss, ownr_id: oid)
  end

  # GET /app_nominas/1/edit
  def edit
  end

  # POST /app_nominas or /app_nominas.json
  def create
    @objeto = AppNomina.new(app_nomina_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Nomina de usuario fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_nominas/1 or /app_nominas/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_nomina_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Nomina de usuario fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_nominas/1 or /app_nominas/1.json
  def destroy
    get_rdrccn
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Nomina de usuario fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_nomina
      @objeto = AppNomina.find(params[:id])
    end

    def get_rdrccn
      if ['Empresa', 'Cliente'].include?(@objeto.ownr_type)
        @rdrccn = "/cuentas/#{@objeto.ownr.class.name.tableize[0]}_#{@objeto.ownr.id}/nmn"
      else
        @rdrccn = "/app_nominas" 
      end
    end

    # Only allow a list of trusted parameters through.
    def app_nomina_params
      params.require(:app_nomina).permit(:nombre, :email, :tipo, :ownr_type, :ownr_id)
    end
end
