class Control::TipoProcedimientosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tipo_procedimiento, only: %i[ show edit update destroy ]

  # GET /tipo_procedimientos or /tipo_procedimientos.json
  def index
    @coleccion = TipoProcedimiento.all
  end

  # GET /tipo_procedimientos/1 or /tipo_procedimientos/1.json
  def show
  end

  # GET /tipo_procedimientos/new
  def new
    @objeto = TipoProcedimiento.new
  end

  # GET /tipo_procedimientos/1/edit
  def edit
  end

  # POST /tipo_procedimientos or /tipo_procedimientos.json
  def create
    @objeto = TipoProcedimiento.new(tipo_procedimiento_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tipo de procedimiento fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_procedimientos/1 or /tipo_procedimientos/1.json
  def update
    respond_to do |format|
      if @objeto.update(tipo_procedimiento_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tipo de procedimiento fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_procedimientos/1 or /tipo_procedimientos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Tipo de procedimiento fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_procedimiento
      @objeto = TipoProcedimiento.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = procedimientos_path
    end

    # Only allow a list of trusted parameters through.
    def tipo_procedimiento_params
      params.require(:tipo_procedimiento).permit(:tipo_procedimiento)
    end
end
