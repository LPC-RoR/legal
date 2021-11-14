class Estados::StPerfilModelosController < ApplicationController
  before_action :set_st_perfil_modelo, only: %i[ show edit update destroy desasignar cambia_rol cambia_ingreso]
  before_action :carga_solo_sidebar, only: %i[ show new edit create update ]

  include Sidebar

  # GET /st_perfil_modelos or /st_perfil_modelos.json
  def index
    @coleccion = StPerfilModelo.all
  end

  # GET /st_perfil_modelos/1 or /st_perfil_modelos/1.json
  def show
  end

  # GET /st_perfil_modelos/new
  def new
    @objeto = StPerfilModelo.new
  end

  # GET /st_perfil_modelos/1/edit
  def edit
  end

  # POST /st_perfil_modelos or /st_perfil_modelos.json
  def create
    @objeto = StPerfilModelo.new(st_perfil_modelo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "St perfil modelo was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /st_perfil_modelos/1 or /st_perfil_modelos/1.json
  def update
    respond_to do |format|
      if @objeto.update(st_perfil_modelo_params)
        format.html { redirect_to @objeto, notice: "St perfil modelo was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def cambia_rol
    nomina = params[:class_name].constantize.find(params[:objeto_id])
    @objeto.rol = (@objeto.rol == 'nomina' ? 'admin' : 'nomina')
    @objeto.save

    redirect_to nomina
  end

  def cambia_ingreso
    nomina = params[:class_name].constantize.find(params[:objeto_id])
    @objeto.ingresa_registros = (@objeto.ingresa_registros == true ? false : true)
    @objeto.save

    redirect_to nomina
  end

  # DELETE /st_perfil_modelos/1 or /st_perfil_modelos/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to st_perfil_modelos_url, notice: "St perfil modelo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def desasignar
    nomina = params[:class_name].constantize.find(params[:objeto_id])
    unless @objeto.st_perfil_estados.any?
      @objeto.delete
    end

    redirect_to nomina
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_st_perfil_modelo
      @objeto = StPerfilModelo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def st_perfil_modelo_params
      params.require(:st_perfil_modelo).permit(:st_perfil_modelo, :rol, :ingresa_registros, :app_perfil_id)
    end
end
