class Control::TareasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tarea, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  include Orden

  # GET /tareas or /tareas.json
  def index
    @coleccion = Tarea.all
  end

  # GET /tareas/1 or /tareas/1.json
  def show
  end

  # GET /tareas/new
  def new
    etapa = params[:oclss].constantize.find(params[:oid])
    orden = etapa.tareas.count + 1
    @objeto = etapa.tareas.new(ctr_etapa_id: etapa.id, orden: orden)
  end

  # GET /tareas/1/edit
  def edit
  end

  # POST /tareas or /tareas.json
  def create
    @objeto = Tarea.new(tarea_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tarea fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tareas/1 or /tareas/1.json
  def update
    respond_to do |format|
      if @objeto.update(tarea_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tarea fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tareas/1 or /tareas/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Tarea fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tarea
      @objeto = Tarea.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.ctr_etapa.procedimiento
    end

    # Only allow a list of trusted parameters through.
    def tarea_params
      params.require(:tarea).permit(:orden, :procedimiento_id, :detalle, :codigo, :tarea, :plazo, :ctr_etapa_id, :sub_procs)
    end
end
