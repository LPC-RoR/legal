class StEstados::StEstadosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_st_estado, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  include Orden

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
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Estado fue exitosamente creado." }
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
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Estado fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /st_estados/1 or /st_estados/1.json
  def destroy
    get_rdrccn
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Estado fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_st_estado
      @objeto = StEstado.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.ownr

    end

    # Only allow a list of trusted parameters through.
    def st_estado_params
      params.require(:st_estado).permit(:orden, :st_estado, :destinos, :destinos_admin, :st_modelo_id, :aprobacion, :check)
    end
end
