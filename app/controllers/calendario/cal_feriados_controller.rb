class Calendario::CalFeriadosController < ApplicationController
  before_action :set_cal_feriado, only: %i[ show edit update destroy ]

  # GET /cal_feriados or /cal_feriados.json
  def index
    @coleccion = CalFeriado.all
  end

  # GET /cal_feriados/1 or /cal_feriados/1.json
  def show
  end

  # GET /cal_feriados/new
  def new
    annio = CalAnnio.find(params[:aid])
    @objeto = annio.cal_feriados.new
  end

  # GET /cal_feriados/1/edit
  def edit
  end

  # POST /cal_feriados or /cal_feriados.json
  def create
    @objeto = CalFeriado.new(cal_feriado_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Feriado fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cal_feriados/1 or /cal_feriados/1.json
  def update
    respond_to do |format|
      if @objeto.update(cal_feriado_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Feriado fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cal_feriados/1 or /cal_feriados/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Feriado fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cal_feriado
      @objeto = CalFeriado.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/tablas/calendario"
    end

    # Only allow a list of trusted parameters through.
    def cal_feriado_params
      params.require(:cal_feriado).permit(:cal_annio_id, :cal_fecha, :descripcion)
    end
end
