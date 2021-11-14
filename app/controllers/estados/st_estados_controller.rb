class Estados::StEstadosController < ApplicationController
  before_action :set_st_estado, only: %i[ show edit update destroy asigna ]
  before_action :carga_solo_sidebar, only: %i[ show new edit create update ]

  include Sidebar

  # GET /st_estados or /st_estados.json
  def index
    @coleccion = StEstado.all
  end

  # GET /st_estados/1 or /st_estados/1.json
  def show
  end

  # GET /st_estados/new
  def new
    @objeto = StEstado.new(st_modelo_id: params[:st_modelo_id])
  end

  # GET /st_estados/1/edit
  def edit
  end

  # POST /st_estados or /st_estados.json
  def create
    @objeto = StEstado.new(st_estado_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "St estado was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /st_estados/1 or /st_estados/1.json
  def update
    respond_to do |format|
      if @objeto.update(st_estado_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "St estado was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def asigna
    nomina = params[:class_name].constantize.find(params[:objeto_id])
    st_perfil_modelo = nomina.st_perfil_modelos.find_by(st_perfil_modelo: @objeto.st_modelo.st_modelo)
    st_perfil_modelo.st_perfil_estados.create(st_perfil_estado: @objeto.st_estado, rol: 'nomina')
    
    redirect_to nomina
  end

  # DELETE /st_estados/1 or /st_estados/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "St estado was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_st_estado
      @objeto = StEstado.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.st_modelo
    end

    # Only allow a list of trusted parameters through.
    def st_estado_params
      params.require(:st_estado).permit(:orden, :st_estado, :destinos, :destinos_admin, :st_modelo_id)
    end
end
