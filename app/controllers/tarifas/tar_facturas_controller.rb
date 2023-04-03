class Tarifas::TarFacturasController < ApplicationController
  before_action :set_tar_factura, only: %i[ show edit update destroy elimina set_documento back_estado set_pago set_facturada]

  include Bandejas

  # GET /tar_facturas or /tar_facturas.json
  def index
    init_bandejas
    init_tab( { menu: ['ingreso', 'facturada', 'pagada'] }, true )

#    @coleccion = {}
#    @coleccion['clientes'] = Cliente.where(id: TarFacturacion.where(estado: 'ingreso').map {|tarf| tarf.padre.cliente.id unless tarf.tar_factura.present?}.compact.uniq)
#    @coleccion['tar_facturas'] = TarFactura.where(estado: @options[:menu]).order(created_at: :desc)
    init_tabla('clientes', Cliente.where(id: TarFacturacion.where(estado: 'ingreso').map {|tarf| tarf.padre.cliente.id unless tarf.tar_factura.present?}.compact.uniq), false)
    add_tabla('tar_facturas', TarFactura.where(estado: @options[:menu]).order(created_at: :desc), false)
  end

  # GET /tar_facturas/1 or /tar_facturas/1.json
  def show
#    @coleccion = {}
#    @coleccion['tar_facturaciones'] = @objeto.tar_facturaciones
    init_tabla('tar_facturaciones', @objeto.tar_facturaciones, false)
  end

  # GET /tar_facturas/new
  def new
    @objeto = TarFactura.new
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
    parametro = false
    unless params[:set_documento][:documento].blank?
      @objeto.documento = params[:set_documento][:documento].to_i
      @objeto.estado = 'facturada'
      @objeto.tar_facturaciones.each do |fact|
        fact.estado = 'facturada'
        fact.save
      end
      parametro = true
    end

    unless params[:set_documento][:fecha_uf].blank? and params[:set_documento][:uf_factura].blank?
      @objeto.fecha_uf = params[:set_documento][:fecha_uf]
      @objeto.uf_factura = params[:set_documento][:uf_factura]
      @objeto.tar_facturaciones.each do |fact|
        if fact.monto_uf.present?
          if fact.monto_uf > 0
            uf_factura = params[:set_documento][:uf_factura].to_f
            fact.monto = (fact.monto_uf * uf_factura)
            fact.save
          end
        end
      end
      parametro = true
    end

    @objeto.save if parametro

    redirect_to @objeto
  end

  def back_estado

    case @objeto.estado
    when 'facturada'
      prev_estado = 'ingreso'
    when 'pagada'
      prev_estado = 'facturada'
    end

    @objeto.estado = prev_estado
    @objeto.tar_facturaciones.each do |fact|
      fact.estado = prev_estado
      fact.save
    end
    @objeto.save

    redirect_to @objeto
  end

  def set_pago
    unless params[:set_pago][:detalle_pago].blank?
      @objeto.detalle_pago = params[:set_pago][:detalle_pago]
      @objeto.estado = 'pagada'
      @objeto.tar_facturaciones.each do |fact|
        fact.estado = 'pagada'
        fact.save
      end
      @objeto.save
    end

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
