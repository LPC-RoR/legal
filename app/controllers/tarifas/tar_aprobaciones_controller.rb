class Tarifas::TarAprobacionesController < ApplicationController
  before_action :set_tar_aprobacion, only: %i[ show edit update destroy facturar ]

  # GET /tar_aprobaciones or /tar_aprobaciones.json
  def index
    init_tabla('tar_aprobaciones', TarAprobacion.all.order(fecha: :desc), true)
    add_tabla('tar_facturaciones', TarFacturacion.where(tar_aprobacion_id: nil, tar_factura_id: nil), false)
  end

  # GET /tar_aprobaciones/1 or /tar_aprobaciones/1.json
  def show
    init_tabla('tar_facturaciones', @objeto.tar_facturaciones, false)

    sin_asignar = TarFacturacion.where(tar_aprobacion_id: nil, tar_factura_id: nil)
    ids_cliente = sin_asignar.map {|sa| sa.id if sa.padre.cliente.id == @objeto.cliente.id}.compact
    add_tabla('pend-tar_facturaciones', TarFacturacion.where(id: ids_cliente), false)
  end

  # GET /tar_aprobaciones/new
  def new
    @objeto = TarAprobacion.new
  end

  # GET /tar_aprobaciones/1/edit
  def edit
  end

  # POST /tar_aprobaciones or /tar_aprobaciones.json
  def create
    @objeto = TarAprobacion.new(tar_aprobacion_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Aprobación fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_aprobaciones/1 or /tar_aprobaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_aprobacion_params)
        format.html { redirect_to @objeto, notice: "Aprobación fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def facturar
    if @objeto.tar_facturaciones.where(tar_factura_id: nil).any?
      factura = TarFactura.create(owner_class: 'Cliente', owner_id: @objeto.cliente.id, estado: 'ingreso')
      unless factura.blank?
        @objeto.tar_facturaciones.where(tar_factura_id: nil).each do |facturacion|
          factura.tar_facturaciones << facturacion
        end
      end
      if factura.blank?
        redirect_to @objeto, notice: 'No se pudo crear la factura'
      else
        redirect_to factura, notice: 'Factura ha sido exitósamente creada'
      end
    else
      redirect_to @objeto, notice: 'No hay pagos que facturables'
    end
  end

  # DELETE /tar_aprobaciones/1 or /tar_aprobaciones/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to tar_aprobaciones_url, notice: "Aprobación fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_aprobacion
      @objeto = TarAprobacion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tar_aprobacion_params
      params.require(:tar_aprobacion).permit(:cliente_id, :fecha)
    end
end
