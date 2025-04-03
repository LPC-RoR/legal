class Control::ProcedimientosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_procedimiento, only: %i[ show edit update destroy ]

  # GET /procedimientos or /procedimientos.json
  def index
    set_tabla('procedimientos', Procedimiento.all.order(:procedimiento), true)
    set_tabla('tipo_procedimientos', TipoProcedimiento.all.order(:tipo_procedimiento), false)
  end

  # GET /procedimientos/1 or /procedimientos/1.json
  def show
    set_tabla('ctr_etapas', @objeto.ctr_etapas.ordr, false)
    set_tabla('rep_doc_controlados', @objeto.rep_doc_controlados.ordr, false)
    set_tabla('lgl_temas', @objeto.lgl_temas.ordr, false)
  end

  # GET /procedimientos/new
  def new
    @objeto = Procedimiento.new
  end

  # GET /procedimientos/1/edit
  def edit
  end

  # POST /procedimientos or /procedimientos.json
  def create
    @objeto = Procedimiento.new(procedimiento_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Procedimiento fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /procedimientos/1 or /procedimientos/1.json
  def update
    respond_to do |format|
      if @objeto.update(procedimiento_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Procedimiento fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /procedimientos/1 or /procedimientos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Procedimiento fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_procedimiento
      @objeto = Procedimiento.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = procedimientos_path
    end

    # Only allow a list of trusted parameters through.
    def procedimiento_params
      params.require(:procedimiento).permit(:procedimiento, :tipo_procedimiento_id, :detalle, :codigo)
    end
end
