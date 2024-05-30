class Tarifas::TarFacturacionesController < ApplicationController
  before_action :set_tar_facturacion, only: %i[ show edit update destroy elimina facturable facturar estado crea_aprobacion a_aprobacion a_pendiente elimina_facturacion ]

  include Tarifas

  # GET /tar_facturaciones or /tar_facturaciones.json
  def index
  end

  # GET /tar_facturaciones/1 or /tar_facturaciones/1.json
  def show
  end

  # GET /tar_facturaciones/new
  def new
  end

  # Crea PAGO que será trasformado en el detalle de la factura
  # 1.- owner.class.name : {'RegReporte', 'Asesoria', 'Causa'}
  def crea_facturacion
    # owner : CAUSA | RegREPORTE? | ASESORIA?
    owner = params[:owner_class].constantize.find(params[:owner_id])

    case params[:owner_class]
    when 'Causa'

      # Cálculo de tarifa
      # En esta versión sólo procesaremos pagos,
      # no sirve generar facturaciones desde cuuotas porque nos impide manejar aprobaciones.
      pago = TarPago.find(params[:pid]) unless params[:pid].blank?
      moneda  = (pago.moneda.blank? ? 'UF' : pago.moneda)
      cuantia_calculo = t_cuantia_pesos(owner, pago, 'honorarios')

      # monto = pago.valor.blank? ? calcula2( formula, owner, pago).round(pago.moneda.blank? ? 5 : (pago.moneda == 'Pesos' ? 0 : 5)) : pago.valor
      if pago.valor.blank?
        formula = pago.codigo_formula
        monto = calcula2( formula, owner, pago).round(pago.moneda.blank? ? 5 : (pago.moneda == 'Pesos' ? 0 : 5))
      else
        monto = pago.valor
      end
      

      glosa = "#{pago.tar_pago} : #{owner.rit} #{owner.causa}"
      unless monto == 0
        # en esta version le sacamos cliente_class porque no tiene sentido, no hay otro modelo que pueda ser el cliente Cliente
        TarFacturacion.create(cliente_id: owner.cliente.id, owner_class: owner.class.name, owner_id: owner.id, tar_pago_id: pago.id, moneda: moneda, monto: monto, glosa: glosa, estado: 'aprobación', cuantia_calculo: cuantia_calculo, pago_calculo: monto)
      end

      owner.causa_ganada = owner.monto_pagado == 0
      owner.save

      # En esta nueva versión 'terminada' es aquella que ya no tiene gestiones pendientes
#      if owner.facturaciones.count == owner.tar_tarifa.n_pagos
#        owner.estado = 'terminada'
#      else
#        owner.estado = 'tramitación'
#      end

#      owner.save

    when 'Asesoria'
      moneda = (owner.moneda.blank? or owner.monto.blank?) ? owner.tar_servicio.moneda : owner.moneda
      monto = (owner.moneda.blank? or owner.monto.blank?) ? owner.tar_servicio.monto : owner.monto
      tf=TarFacturacion.create(cliente_id: owner.cliente.id, owner_class: owner.class.name, owner_id: owner.id, glosa: owner.descripcion, estado: 'ingreso', moneda: moneda, monto: monto )
      unless tf.blank?
        owner.estado = 'terminada'
        owner.save
      end
    when 'RegReporte'
      TarFacturacion.create(cliente_id: owner.owner.cliente.id, owner_class: owner.class.name, owner_id: owner.id, facturable: params[:facturable], glosa: params[:facturable], estado: 'ingreso', moneda: owner.moneda_reporte, monto: owner.monto_reporte )
    end

    redirect_to ( params[:owner_class] == 'Asesoria' ? asesorias_path : "/#{owner.class.name.tableize}/#{owner.id}?html_options[menu]=Tarifa+%26+Pagos" )
  end

  def crea_aprobacion
    cliente = @objeto.padre.cliente
    # crea aprobacion
    aprobacion = cliente.tar_aprobaciones.create(cliente_id: cliente.id, fecha: Time.zone.today.to_date)
    aprobacion.tar_facturaciones << @objeto
    # asocia todas las facturaciones del cliente disponibles
    disponibles = TarFacturacion.where(tar_aprobacion_id: nil, tar_factura_id: nil)
    disponibles.each do |factn|
      aprobacion.tar_facturaciones << factn if factn.padre.cliente.id == cliente.id
    end

    redirect_to aprobacion, notice: 'Aprobación fue exitósamente creada'
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
        format.html { redirect_to @redireccion, notice: "Tar facturacion was successfully created." }
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
        format.html { redirect_to @redireccion, notice: "Tar facturacion was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def elimina_facturacion
    owner = @objeto.owner_class.constantize.find(@objeto.owner_id)
    unless owner.blank?
      @objeto.delete
      owner.estado = 'ingreso'
      owner.save
    end

    redirect_to asesorias_path
  end

  def a_aprobacion
    aprobacion = TarAprobacion.find(params[:indice])
    aprobacion.tar_facturaciones << @objeto

    redirect_to aprobacion
  end

  def a_pendiente
    aprobacion = TarAprobacion.find(params[:indice])
    aprobacion.tar_facturaciones.delete(@objeto)

    redirect_to aprobacion
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
      format.html { redirect_to @redireccion, notice: "Tar facturacion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Elimina TarFactura de CAUSA/REG_REPORTE
  def elimina
    owner = params[:class_name].constantize.find(params[:objeto_id])
    @objeto.delete

    if owner.class.name == 'Causa'
      if owner.facturaciones.count == owner.tar_tarifa.tar_pagos.count
        owner.estado = 'terminada'
      else
        owner.estado = 'tramitación'
      end
      owner.save
    end

    redirect_to "/#{owner.class.name.tableize}/#{owner.id}?html_options[menu]=Tarifa+%26+Pagos"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_facturacion
      @objeto = TarFacturacion.find(params[:id])
    end

    def set_redireccion
      @redireccion = ( @objeto.owner.class.name == 'Asesoria' ? asesorias_path : "/#{@objeto.owner.class.name.tableize}/#{@objeto.owner.id}?html_options[menu]=Tarifa+%26+Pagos" )
    end

    # Only allow a list of trusted parameters through.
    def tar_facturacion_params
      params.require(:tar_facturacion).permit(:facturable, :glosa, :monto, :estado, :owner_class, :owner_id, :tar_factura_id, :moneda)
    end
end
