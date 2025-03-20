class Tarifas::TarCuotasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tar_cuota, only: %i[ show edit update destroy arriba abajo]
  after_action :reordenar, only: :destroy

  # GET /tar_cuotas or /tar_cuotas.json
  def index
    @coleccion = TarCuota.all
  end

  # GET /tar_cuotas/1 or /tar_cuotas/1.json
  def show
  end

  # GET /tar_cuotas/new
  def new
    ownr = TarPago.find(params[:oid])
    @objeto = TarCuota.new(tar_pago_id: ownr.id, orden: ownr.tar_cuotas.count + 1)
  end

  # GET /tar_cuotas/1/edit
  def edit
  end

  # POST /tar_cuotas or /tar_cuotas.json
  def create
    @objeto = TarCuota.new(tar_cuota_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Cuota del pago ha sido exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_cuotas/1 or /tar_cuotas/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_cuota_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Cuota del pago ha sido exitósamente actualizada." }
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

  # DELETE /tar_cuotas/1 or /tar_cuotas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Cuota del pago ha sido exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    def reordenar
      @objeto.list.each_with_index do |val, index|
        unless val.orden == index + 1
          val.orden = index + 1
          val.save
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_tar_cuota
      @objeto = TarCuota.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.tar_pago
    end

    # Only allow a list of trusted parameters through.
    def tar_cuota_params
      params.require(:tar_cuota).permit(:tar_pago_id, :orden, :tar_cuota, :moneda, :monto, :porcentaje, :ultima_cuota)
    end
end
