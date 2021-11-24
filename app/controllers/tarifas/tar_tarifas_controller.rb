class Tarifas::TarTarifasController < ApplicationController
  before_action :set_tar_tarifa, only: %i[ show edit update destroy asigna desasigna ]

  # GET /tar_tarifas or /tar_tarifas.json
  def index
    @coleccion = TarTarifa.all
  end

  # GET /tar_tarifas/1 or /tar_tarifas/1.json
  def show
    @coleccion = {}
    @coleccion['tar_elementos'] = TarElemento.all.order(:elemento)
    @coleccion['tar_detalles'] = @objeto.tar_detalles.order(:orden)
  end

  # GET /tar_tarifas/new
  def new
    @objeto = TarTarifa.new(owner_class: params[:class_name], owner_id: params[:objeto_id], estado: 'ingreso')
  end

  # GET /tar_tarifas/1/edit
  def edit
  end

  # POST /tar_tarifas or /tar_tarifas.json
  def create
    @objeto = TarTarifa.new(tar_tarifa_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar tarifa was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_tarifas/1 or /tar_tarifas/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_tarifa_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar tarifa was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def asigna

    objeto = params[:class_name].constantize.find(params[:objeto_id])
    @objeto.send(params[:class_name].tableize) << objeto

    redirect_to objeto

#    causa = params[:class_name].constantize.find(params[:objeto_id])
#    @objeto.causas << causa

#    redirect_to causa
  end

  def desasigna
    objeto = params[:class_name].constantize.find(params[:objeto_id])
    @objeto.send(params[:class_name].tableize).delete(objeto)

    redirect_to objeto

#    causa = params[:class_name].constantize.find(params[:objeto_id])
#    @objeto.causas.delete(causa)

#    redirect_to causa
  end

  # DELETE /tar_tarifas/1 or /tar_tarifas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tar tarifa was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_tarifa
      @objeto = TarTarifa.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.padre
    end

    # Only allow a list of trusted parameters through.
    def tar_tarifa_params
      params.require(:tar_tarifa).permit(:tarifa, :estado, :facturables, :owner_class, :owner_id)
    end
end
