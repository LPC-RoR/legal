class Tarifas::TarFacturasController < ApplicationController
  before_action :set_tar_factura, only: %i[ show edit update destroy elimina set_documento cambio_estado set_pago set_facturada]

  include Tarifas

  # GET /tar_facturas or /tar_facturas.json
  def index
    init_tabla('ingreso-tar_facturas', TarFactura.where(estado: 'ingreso').order(documento: :desc), false)
    add_tabla('facturada-tar_facturas', TarFactura.where(estado: 'facturada').order(documento: :desc), false)
    add_tabla('pagada-tar_facturas', TarFactura.where(estado: 'pagada').order(documento: :desc), true)
  end

  # GET /tar_facturas/1 or /tar_facturas/1.json
  def show
    init_tabla('tar_facturaciones', @objeto.tar_facturaciones, false)
  end

  # GET /tar_facturas/new
  def new
    @objeto = TarFactura.new(owner_class: params[:class_name], owner_id: params[:objeto_id], estado: 'ingreso')
  end

  def crea_factura
    factura = TarFactura.create(owner_class: params[:class_name], owner_id: params[:objeto_id], fecha_factura: DateTime.now.to_date, estado: 'ingreso')

    cliente = params[:class_name].constantize.find(params[:objeto_id])

    cliente.facturaciones_pendientes.each do |facturacion|
      factura.tar_facturaciones << facturacion
    end

    redirect_to factura
  end

  # GET /tar_facturas/1/edit
  def edit
  end

  # POST /tar_facturas or /tar_facturas.json
  def create
    @objeto = TarFactura.new(tar_factura_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Tar factura was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_facturas/1 or /tar_facturas/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_factura_params)
        format.html { redirect_to @objeto, notice: "Tar factura was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_documento
    modificado = false
    unless params[:set_documento][:documento].blank?
      @objeto.documento = params[:set_documento][:documento].to_i
      unless params[:set_documento]['fecha_factura(1i)'].blank? or params[:set_documento]['fecha_factura(2i)'].blank? or params[:set_documento]['fecha_factura(3i)'].blank?
        @objeto.fecha_factura = params_to_date(params[:set_documento], 'fecha_factura')
      else
        @objeto.fecha_factura = DateTime.now.to_date
      end
      unless params[:set_documento][:concepto].blank?
        @objeto.concepto = params[:set_documento][:concepto]
      end
      @objeto.estado = 'facturada'
      modificado = true
    else
      if params[:set_documento][:fecha_del_dia] == '1'
        @objeto.fecha_uf = nil
        modificado = true
      end
    end

    unless params[:set_documento]['fecha_uf(1i)'].blank? or params[:set_documento]['fecha_uf(2i)'].blank? or params[:set_documento]['fecha_uf(3i)'].blank?
#      @objeto.fecha_uf = DateTime.new(params[:set_documento]['fecha_uf(1i)'].to_i, params[:set_documento]['fecha_uf(2i)'].to_i, params[:set_documento]['fecha_uf(3i)'].to_i)
      @objeto.fecha_uf = params_to_date(params[:set_documento], 'fecha_uf')
      modificado = true
    else 
      if params[:set_documento][:documento].present?
        @objeto.fecha_uf = @objeto.fecha_factura.blank? ? DateTime.now.to_date : @objeto.fecha_factura
        modificado = true
      end
    end

    @objeto.save if modificado

    redirect_to @objeto
  end

  def cambio_estado
    StLog.create(perfil_id: current_usuario.id, class_name: @objeto.class.name, objeto_id: @objeto.id, e_origen: @objeto.estado, e_destino: params[:st])

    if params[:st] == 'ingreso'
      @objeto.documento = nil
      @objeto.fecha_uf = nil 
    elsif params[:st] == 'facturada'
        @objeto.detalle_pago = nil
    end

    @objeto.estado = params[:st]
    @objeto.save

#    redirect_to "/st_bandejas?m=#{@objeto.class.name}&e=#{@objeto.estado}"
    redirect_to @objeto
  end

  def set_pago
    unless params[:set_pago][:detalle_pago].blank?
      @objeto.detalle_pago = params[:set_pago][:detalle_pago]
      @objeto.estado = 'pagada'
      modificado = true
    else
      if params[:set_pago][:fecha_del_dia] == '1'
        @objeto.fecha_pago = nil
        modificado = true
      end
    end

    unless params[:set_pago]['fecha_pago(1i)'].blank? or params[:set_pago]['fecha_pago(2i)'].blank? or params[:set_pago]['fecha_pago(3i)'].blank?
      @objeto.fecha_pago = DateTime.new(params[:set_pago]['fecha_pago(1i)'].to_i, params[:set_pago]['fecha_pago(2i)'].to_i, params[:set_pago]['fecha_pago(3i)'].to_i)
      modificado = true
    else 
      if params[:set_pago][:detalle_pago].present?
        @objeto.fecha_pago = DateTime.now
        modificado = true
      end
    end

    @objeto.save if modificado

    redirect_to @objeto
  end

  # DELETE /tar_facturas/1 or /tar_facturas/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to tar_facturas_url, notice: "Tar factura was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def elimina
    @objeto.tar_facturaciones.delete_all
    @objeto.delete

    redirect_to tar_facturas_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_factura
      @objeto = TarFactura.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tar_factura_params
      params.require(:tar_factura).permit(:owner_class, :owner_id, :documento, :estado)
    end
end
