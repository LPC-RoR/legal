class Estados::StPerfilEstadosController < ApplicationController
  before_action :set_st_perfil_estado, only: %i[ show edit update destroy desasignar cambia_rol ]
  before_action :carga_solo_sidebar, only: %i[ show new edit create update ]

  include Sidebar

  # GET /st_perfil_estados or /st_perfil_estados.json
  def index
    @coleccion = StPerfilEstado.all
  end

  # GET /st_perfil_estados/1 or /st_perfil_estados/1.json
  def show
  end

  # GET /st_perfil_estados/new
  def new
    @objeto = StPerfilEstado.new
  end

  # GET /st_perfil_estados/1/edit
  def edit
  end

  # POST /st_perfil_estados or /st_perfil_estados.json
  def create
    @objeto = StPerfilEstado.new(st_perfil_estado_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "St perfil estado was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /st_perfil_estados/1 or /st_perfil_estados/1.json
  def update
    respond_to do |format|
      if @objeto.update(st_perfil_estado_params)
        format.html { redirect_to @objeto, notice: "St perfil estado was successfully updated." }
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

  # DELETE /st_perfil_estados/1 or /st_perfil_estados/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to st_perfil_estados_url, notice: "St perfil estado was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def desasignar
    nomina = params[:class_name].constantize.find(params[:objeto_id])
    @objeto.delete

    redirect_to nomina
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_st_perfil_estado
      @objeto = StPerfilEstado.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def st_perfil_estado_params
      params.require(:st_perfil_estado).permit(:st_perfil_estado, :rol, :st_perfil_modelo_id)
    end
end
