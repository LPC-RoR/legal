class StEstados::StEstadosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_st_estado, only: %i[ show edit update destroy asigna arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /st_estados or /st_estados.json
  def index
  end

  # GET /st_estados/1 or /st_estados/1.json
  def show
  end

  # GET /st_estados/new
  def new
    owner = StModelo.find(params[:st_modelo_id])
    @objeto = owner.st_estados.new(orden: owner.st_estados.count + 1)
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
        format.html { redirect_to @redireccion, notice: "Estado fue exitósamente creado." }
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
        format.html { redirect_to @redireccion, notice: "Estado fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def arriba
    owner = @objeto.owner
    anterior = @objeto.anterior
    @objeto.orden -= 1
    @objeto.save
    anterior.orden += 1
    anterior.save

    redirect_to @objeto.redireccion
  end

  def abajo
    owner = @objeto.owner
    siguiente = @objeto.siguiente
    @objeto.orden += 1
    @objeto.save
    siguiente.orden -= 1
    siguiente.save

    redirect_to @objeto.redireccion
  end

  def reordenar
    @objeto.list.each_with_index do |val, index|
      unless val.orden == index + 1
        val.orden = index + 1
        val.save
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
      format.html { redirect_to @redireccion, notice: "Estado fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_st_estado
      @objeto = StEstado.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/st_modelos" 

    end

    # Only allow a list of trusted parameters through.
    def st_estado_params
      params.require(:st_estado).permit(:orden, :st_estado, :destinos, :destinos_admin, :st_modelo_id, :aprobacion, :check)
    end
end
