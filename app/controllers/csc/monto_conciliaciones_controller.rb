class Csc::MontoConciliacionesController < ApplicationController
  before_action :set_monto_conciliacion, only: %i[ show edit update destroy ]

  # GET /monto_conciliaciones or /monto_conciliaciones.json
  def index
    @coleccion = MontoConciliacion.all
  end

  # GET /monto_conciliaciones/1 or /monto_conciliaciones/1.json
  def show
  end

  # GET /monto_conciliaciones/new
  def new
    @objeto = MontoConciliacion.new
  end

  def nuevo
    causa = Causa.find(params[:cid])
    f_prms = params[:monto_conciliacion]

    annio = f_prms['fecha(1i)'].blank? ? hoy.year : f_prms['fecha(1i)']
    mes = f_prms['fecha(2i)'].blank? ? hoy.month : f_prms['fecha(2i)']
    dia = f_prms['fecha(3i)']
    fecha = Time.zone.parse("#{dia}-#{mes}-#{annio} 00:00")
    unless f_prms.blank? or causa.blank?
      causa.monto_conciliaciones.create(fecha: fecha, tipo: f_prms[:tipo], monto: f_prms[:monto])
    end

    redirect_to causas_path
  end

  # GET /monto_conciliaciones/1/edit
  def edit
  end

  # POST /monto_conciliaciones or /monto_conciliaciones.json
  def create
    @objeto = MontoConciliacion.new(monto_conciliacion_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to monto_conciliacion_url(@objeto), notice: "Monto conciliacion was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monto_conciliaciones/1 or /monto_conciliaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(monto_conciliacion_params)
        format.html { redirect_to monto_conciliacion_url(@objeto), notice: "Monto conciliacion was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monto_conciliaciones/1 or /monto_conciliaciones/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to monto_conciliaciones_url, notice: "Monto conciliacion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monto_conciliacion
      @objeto = MontoConciliacion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def monto_conciliacion_params
      params.require(:monto_conciliacion).permit(:causa_id, :tipo, :fecha, :monto)
    end
end
