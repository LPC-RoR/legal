class Aplicacion::AppNominasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :inicia_sesion
  before_action :set_app_nomina, only: %i[ show edit update destroy ]
  before_action :carga_solo_sidebar, only: %i[ show new edit create update ]

  include Sidebar

  # GET /app_nominas or /app_nominas.json
  def index
    @coleccion = AppNomina.all
  end

  # GET /app_nominas/1 or /app_nominas/1.json
  def show
    carga_sidebar('Administración', 'Nómina')
    @modelos_disponibles = StModelo.where(st_modelo: (StModelo.all.map {|st_mod| st_mod.st_modelo} - @objeto.st_perfil_modelos.map {|st_mod| st_mod.st_perfil_modelo}))
  end

  # GET /app_nominas/new
  def new
    carga_sidebar('Administración', 'Nómina')
    @objeto = AppNomina.new
  end

  # GET /app_nominas/1/edit
  def edit
    carga_sidebar('Administración', 'Nómina')
  end

  # POST /app_nominas or /app_nominas.json
  def create
    @objeto = AppNomina.new(app_nomina_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "App nomina was successfully created." }
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
        set_redireccion
        format.html { redirect_to @redireccion, notice: "App nomina was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_nominas/1 or /app_nominas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "App nomina was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_nomina
      @objeto = AppNomina.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/app_recursos/administracion?id=#{get_elemento_id(controller_name, 'Nómina')}" 
    end

    # Only allow a list of trusted parameters through.
    def app_nomina_params
      params.require(:app_nomina).permit(:nombre, :email, :tipo)
    end
end
