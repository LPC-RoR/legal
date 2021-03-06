class Tarifas::TarFacturacionesController < ApplicationController
  before_action :set_tar_facturacion, only: %i[ show edit update destroy elimina facturable ]

  include Tarifas

  # GET /tar_facturaciones or /tar_facturaciones.json
  def index
    @coleccion = TarFacturacion.all
  end

  # GET /tar_facturaciones/1 or /tar_facturaciones/1.json
  def show
  end

  # GET /tar_facturaciones/new
  def new
    @objeto = TarFacturacion.new
  end

  def crea_facturacion
    causa = params[:owner_class].constantize.find(params[:owner_id])
    
    unless do_eval(causa, params[:facturable]) == 0
      tar_detalle = causa.tar_tarifa.tar_detalles.find_by(codigo: params[:facturable])
      TarFacturacion.create(owner_class: 'Causa', owner_id: causa.id, facturable: params[:facturable], glosa: "#{tar_detalle.detalle} : #{causa.identificador} #{causa.causa}", estado: 'ingreso', monto: do_eval(causa, params[:facturable]))
    end

    redirect_to "/causas/#{causa.id}?html_options[tab]=Facturación"
  end

  # GET /tar_facturaciones/1/edit
  def edit
  end

  # POST /tar_facturaciones or /tar_facturaciones.json
  def create
    @objeto = TarFacturacion.new(tar_facturacion_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Tar facturacion was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_facturaciones/1 or /tar_facturaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_facturacion_params)
        format.html { redirect_to @objeto, notice: "Tar facturacion was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def facturable
    tar_factura = @objeto.tar_factura
    tar_factura.tar_facturaciones.delete(@objeto)

    if tar_factura.tar_facturaciones.empty?
      tar_factura.delete
      redirect_to tar_facturas_path
    else
      concepto = (tar_factura.tar_facturaciones.count == 1 ? tar_factura.tar_facturaciones.first.glosa : "Varios de cliente #{tar_factura.padre.razon_social}")
      tar_factura.concepto = concepto
      tar_factura.save
      redirect_to tar_factura
    end

  end

  # DELETE /tar_facturaciones/1 or /tar_facturaciones/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to tar_facturaciones_url, notice: "Tar facturacion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def elimina
    causa = params[:class_name].constantize.find(params[:objeto_id])

    @objeto.delete

    redirect_to causa
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_facturacion
      @objeto = TarFacturacion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tar_facturacion_params
      params.require(:tar_facturacion).permit(:facturable, :glosa, :monto, :estado, :owner_class, :owner_id)
    end
end
