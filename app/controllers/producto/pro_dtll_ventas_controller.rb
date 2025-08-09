class Producto::ProDtllVentasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_pro_dtll_venta, only: %i[ show edit update destroy ]

  # GET /pro_dtll_ventas or /pro_dtll_ventas.json
  def index
    @coleccion = ProDtllVenta.all
  end

  # GET /pro_dtll_ventas/1 or /pro_dtll_ventas/1.json
  def show
  end

  # GET /pro_dtll_ventas/new
  def new
    @objeto = ProDtllVenta.new(ownr_type: params[:oclss], ownr_id: params[:oid], fecha_activacion: Time.zone.now)
  end

  # GET /pro_dtll_ventas/1/edit
  def edit
  end

  # POST /pro_dtll_ventas or /pro_dtll_ventas.json
  def create
    @objeto = ProDtllVenta.new(pro_dtll_venta_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Producto fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pro_dtll_ventas/1 or /pro_dtll_ventas/1.json
  def update
    respond_to do |format|
      if @objeto.update(pro_dtll_venta_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Producto fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pro_dtll_ventas/1 or /pro_dtll_ventas/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Producto fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pro_dtll_venta
      @objeto = ProDtllVenta.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = "/#{@objeto.ownr.class.name.tableize}/#{@objeto.ownr.id}#{"?html_options[menu]=Productos" if @objeto.ownr.class.name == 'Cliente'}"
    end

    # Only allow a list of trusted parameters through.
    def pro_dtll_venta_params
      params.require(:pro_dtll_venta).permit(:ownr_type, :ownr_id, :producto_id, :fecha_activacion)
    end
end
