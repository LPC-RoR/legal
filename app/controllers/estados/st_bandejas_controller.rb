class Estados::StBandejasController < ApplicationController
  before_action :set_st_bandeja, only: %i[ show edit update destroy ]

  # GET /st_bandejas or /st_bandejas.json
  def index
    # Manejo del sidebar
    unless StModelo.all.empty?
      @m = params[:m].blank? ? StModelo.all.order(:st_modelo).first.st_modelo : params[:m]
      if StModelo.find_by(st_modelo: @m).blank?
        @e = nil
      else
        @e = (params[:e].blank? ? 'ingreso' : params[:e])
      end
    else
      @m = nil
      @e = nil
    end

    # Despliegue
    @coleccion = {}
    estado = (@e == 'st_plus' ? 'ingreso' : @e)
    @coleccion[@m.tableize] = @m.constantize.where(estado: estado).order(:created_at)

    @nomina = AppNomina.find_by(email: perfil_activo.email) unless seguridad_desde('admin')

  end

  # GET /st_bandejas/1 or /st_bandejas/1.json
  def show
  end

  # GET /st_bandejas/new
  def new
    @objeto = StBandeja.new
  end

  # GET /st_bandejas/1/edit
  def edit
  end

  # POST /st_bandejas or /st_bandejas.json
  def create
    @objeto = StBandeja.new(st_bandeja_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "St bandeja was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /st_bandejas/1 or /st_bandejas/1.json
  def update
    respond_to do |format|
      if @objeto.update(st_bandeja_params)
        format.html { redirect_to @objeto, notice: "St bandeja was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /st_bandejas/1 or /st_bandejas/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to st_bandejas_url, notice: "St bandeja was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_st_bandeja
      @objeto = StBandeja.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def st_bandeja_params
      params.fetch(:st_bandeja, {})
    end
end
