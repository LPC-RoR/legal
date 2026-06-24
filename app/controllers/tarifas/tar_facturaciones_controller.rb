class Tarifas::TarFacturacionesController < ApplicationController
  before_action :set_tar_facturacion, only: %i[ show edit update destroy swtch niler facturable facturar crea_aprobacion a_aprobacion libera_facturacion ]

  include Tarifas

  # GET /tar_facturaciones or /tar_facturaciones.json
  def index
  end

  # GET /tar_facturaciones/1 or /tar_facturaciones/1.json
  def show
  end

  # GET /tar_facturaciones/new
  def new
    # Hay que completar con los casos de Asesoría y Cargos (si corresponde)
    case params[:code]
    when 'clcl'
      calculo = TarCalculo.find(params[:bid])
      # No es necesario relacionarlo con la causa si OWNR es Causa, Modificar cuando se trabaje con Asesorias
#      ownr    = calculo.ownr
    end
    @objeto = calculo.tar_facturaciones.new(codigo_formula: calculo.codigo_formula, glosa: calculo.glosa)
  end

  def crea_aprobacion
    cliente = @objeto.ownr_cliente    # Resuelto para Causa y Asesoria
    # crea aprobacion
    aprobacion = cliente.tar_aprobaciones.create(cliente_id: cliente.id, fecha: Time.zone.today.to_date)
    aprobacion.tar_facturaciones << @objeto
    # asocia todas las facturaciones del cliente disponibles
    disponibles = TarFacturacion.dspnbls
    disponibles.each do |factn|
      aprobacion.tar_facturaciones << factn if factn.ownr_cliente.id == cliente.id
    end

    redirect_to aprobacion, notice: 'Aprobación fue exitosamente creada'
  end

  # GET /tar_facturaciones/1/edit
  def edit
  end

  # POST /tar_facturaciones or /tar_facturaciones.json
  def create
    @objeto = TarFacturacion.new(tar_facturacion_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "El pago fue exitosamente creado." }
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
        set_redireccion
        format.html { redirect_to @redireccion, notice: "El pago fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def a_aprobacion
    aprobacion = TarAprobacion.find(params[:indice])
    aprobacion.tar_facturaciones << @objeto

    redirect_to aprobacion
  end

  def libera_facturacion
    @objeto.tar_aprobacion_id = nil
    @objeto.save

    redirect_to tar_aprobaciones_path
  end

  def facturar
    factura = params[:class_name].constantize.find(params[:objeto_id])

    factura.tar_facturaciones << @objeto

    redirect_to factura
  end

  def facturable

    tar_factura = @objeto.tar_factura
    tar_factura.tar_facturaciones.delete(@objeto)

    concepto = (tar_factura.tar_facturaciones.count == 1 ? tar_factura.tar_facturaciones.first.glosa : "Varios de cliente #{tar_factura.padre.razon_social}")
    tar_factura.concepto = concepto
    tar_factura.save
    redirect_to tar_factura

  end

  # DELETE /tar_facturaciones/1 or /tar_facturaciones/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "El pago fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_facturacion
      @objeto = TarFacturacion.find(params[:id])
    end

    def set_redireccion
      if @objeto.tar_calculo_id.present?
          @redireccion = "/causas/#{@objeto.tar_calculo.ownr.id}?html_options[menu]=Tarifa+%26+Pagos"
      else
        case @objeto.ownr_type
        when 'Causa'
          @redireccion = "/causas/#{@objeto.ownr.id}?html_options[menu]=Tarifa+%26+Pagos"
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def tar_facturacion_params
      params.require(:tar_facturacion).permit(:ownr_type, :ownr_id, :tar_calculo_id, :glosa, :monto, :monto_parcial, :porcentaje, :estado, :moneda, :recalcular, :tipo_monto)
    end
end
