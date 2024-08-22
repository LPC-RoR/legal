class Dt::DtTramosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_dt_tramo, only: %i[ show edit update destroy ]

  # GET /dt_tramos or /dt_tramos.json
  def index
    @coleccion = DtTramo.all
  end

  # GET /dt_tramos/1 or /dt_tramos/1.json
  def show
  end

  # GET /dt_tramos/new
  def new
    orden = DtTramo.all.count + 1
    @objeto = DtTramo.new(orden: orden)
  end

  # GET /dt_tramos/1/edit
  def edit
  end

  # POST /dt_tramos or /dt_tramos.json
  def create
    @objeto = DtTramo.new(dt_tramo_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tramo de multas fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dt_tramos/1 or /dt_tramos/1.json
  def update
    respond_to do |format|
      if @objeto.update(dt_tramo_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tramo de multas fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dt_tramos/1 or /dt_tramos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Tramo de multas fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dt_tramo
      @objeto = DtTramo.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = lgl_documentos_path
    end

    # Only allow a list of trusted parameters through.
    def dt_tramo_params
      params.require(:dt_tramo).permit(:dt_tramo, :orden, :min, :max)
    end
end
