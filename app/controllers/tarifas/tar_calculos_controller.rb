class Tarifas::TarCalculosController < ApplicationController
  before_action :set_tar_calculo, only: %i[ show edit update destroy elimina_calculo liberar_calculo crea_aprobacion ]

  include Tarifas

  # GET /tar_calculos or /tar_calculos.json
  def index
    @coleccion = TarCalculo.all
  end

  # GET /tar_calculos/1 or /tar_calculos/1.json
  def show
  end

  # GET /tar_calculos/new
  def new
    @objeto = TarCalculo.new
  end

  def crea_calculo
    ownr = params[:oclss].constantize.find(params[:oid])
    case params[:oclss]
    when 'Causa'
      pid = params[:pid]
      pago = pid.blank? ? nil : TarPago.find(pid)
      cuotas = pago.blank? ? [] : pago.tar_cuotas.ordr
      moneda  = (pago.moneda.blank? ? 'UF' : pago.moneda)
      cuantia_calculo = get_total_cuantia(ownr, 'tarifa')

      tar_uf_facturacion    = get_tar_uf_facturacion_pago(ownr, pago)
      objt_calculo          = get_objt_pago(ownr, pago)
      objt_origen           = tar_uf_facturacion.blank? ? objt_calculo : tar_uf_facturacion
      fecha_calculo         = objt_origen.blank? ? Time.zone.today : objt_origen.fecha_uf
      uf_calculo            = vlr_uf(fecha_calculo)
      # REVISAR calcula2 y evitar pasar formula si ya está en el pago
      if pago.valor.blank?
        formula = pago.codigo_formula
        mnt = calcula2( formula, ownr, pago).round(pago.moneda.blank? ? 5 : (pago.moneda == 'Pesos' ? 0 : 5))
      else
        mnt = pago.valor
      end
      # monto siempre está en Pesos, las cuotas dividen un monto único establecido en el cálculo
      monto = moneda == 'UF' ? (uf_calculo.blank? ? 0 : uf_calculo * mnt) : mnt
      glosa = "#{pago.tar_pago} : #{ownr.rit} #{ownr.causa}"

      # en esta version le sacamos la relación con Cliente. No tiene sentido ver lso cálculos de un cliente
      cll = ownr.tar_calculos.create(tar_pago_id: pid, fecha_uf: fecha_calculo, moneda: 'Pesos', monto: monto, glosa: glosa, cuantia: cuantia_calculo)
      unless cll.blank? or monto == 0
        if cuotas.empty?
          ownr.tar_facturaciones.create(tar_pago_id: pid, tar_calculo_id: cll.id, fecha_uf: fecha_calculo, moneda: 'Pesos', monto: monto, glosa: glosa, cuantia_calculo: cuantia_calculo)
        else
          # PROBAR: Generación de cuotas!
          cuotas.each do |cuota|
            monto_procesado = ownr.tar_facturaciones.map {|fctcn| fctcn.monto}.sum
            c_glosa = "#{glosa} #{cuota.orden} de #{cuotas.count}"

            if cuota.monto.present?
              monto_cuota = cuota.monto
            elsif cuota.ultima_cuota
              monto_cuota = (monto - monto_procesado)
            else
              monto_cuota = monto * (cuota.porcentaje / 100)
            end
            monto_cta = moneda == 'UF' ? (uf_calculo.blank? ? 0 : uf_calculo * monto_cuota) : monto_cuota
            ownr.tar_facturaciones.create(tar_pago_id: pid, tar_calculo_id: cll.id, tar_cuota_id: cuota.id, fecha_uf: fecha_calculo, moneda: 'Pesos', monto: monto_cta, glosa: c_glosa, cuantia_calculo: cuantia_calculo)
          end
        end
      end

      n_clcls = ownr.tar_calculos.count 
      n_pgs   = ownr.tar_tarifa.tar_pagos.count

      ownr.estado = n_clcls == 0 ? 'ingreso' : (n_clcls == n_pgs ? 'terminada' : (ownr.monto_pagado.blank? ? 'tramitación' : 'pagada'))

      # CAUSA GANADA !!
      ownr.causa_ganada = ownr.monto_pagado == 0
      ownr.save
    end

    redirect_to "/#{ownr.class.name.tableize}/#{ownr.id}?html_options[menu]=Tarifa+%26+Pagos"
  end

  def crea_pago_asesoria
    @objeto = params[:oclss].constantize.find(params[:oid])
    dscrpcn = params[:oclss] == 'Asesoria' ? @objeto.descripcion : @objeto.cargo
    calculo = TarCalculo.create(ownr_type: @objeto.class.name, ownr_id: params[:oid], cliente_id: @objeto.cliente_id, fecha_uf: @objeto.fecha_uf_facturacion, monto: @objeto.monto_factura, moneda: 'Pesos', glosa: dscrpcn)
    TarFacturacion.create(ownr_type: @objeto.class.name, ownr_id: params[:oid], tar_calculo_id: calculo.id, fecha_uf: @objeto.fecha_uf_facturacion, monto: @objeto.monto_factura, moneda: 'Pesos', glosa: dscrpcn)

    redirect_to "/#{@objeto.class.name.tableize}"
  end

  def elimina_pago_asesoria
    @objeto = params[:oclss].constantize.find(params[:oid])
    calculo = @objeto.tar_calculo
    pago = @objeto.tar_facturacion
    pago.delete
    calculo.delete

    redirect_to "/#{@objeto.class.name.tableize}"
  end

  # GET /tar_calculos/1/edit
  def edit
  end

  # POST /tar_calculos or /tar_calculos.json
  def create
    @objeto = TarCalculo.new(tar_calculo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Calculo fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_calculos/1 or /tar_calculos/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_calculo_params)
        format.html { redirect_to @objeto, notice: "Calculo fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def elimina_calculo
    causa = @objeto.ownr
    # NO funciona -> @objeto.tar_facturaciones.delete_all
    @objeto.tar_facturaciones.each do |fctn|
      fctn.delete
    end
    @objeto.delete

    if causa.tar_facturaciones.count == causa.tar_tarifa.tar_pagos.count
      causa.estado = 'terminada'
    else
      causa.estado = causa.monto_pagado.blank? ? 'tramitación' : 'pagada'
    end
    causa.save

    redirect_to "/causas/#{causa.id}?html_options[menu]=Tarifa+%26+Pagos"
  end

  def crea_aprobacion
    cliente   = @objeto.ownr_cliente
    oclss     = @objeto.ownr_type
    clss_arry = oclss == 'Causa' ? ['Causa'] : ['Asesoria', 'Cargo']
    # crea aprobacion
    aprobacion = cliente.tar_aprobaciones.create(cliente_id: cliente.id, fecha: Time.zone.today.to_date)
    aprobacion.tar_calculos << @objeto
    # asocia todas las facturaciones del cliente disponibles
    disponibles = TarCalculo.no_aprbcn
    disponibles.each do |ccl|
      aprobacion.tar_calculos << ccl if (ccl.ownr_cliente.id == cliente.id and clss_arry.include?(ccl.ownr_type))
    end

    rdccn = oclss == 'Causa' ? "/causas/#{@objeto.ownr.id}?html_options[menu]=Tarifa+%26+Pagos" : "/#{@objeto.ownr_type.tableize}"
    redirect_to rdccn
  end

  def liberar_calculo
    causa = @objeto.ownr
    @objeto.tar_aprobacion_id = nil
    @objeto.save

    redirect_to tar_aprobaciones_path
  end

  # DELETE /tar_calculos/1 or /tar_calculos/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to tar_calculos_url, notice: "Calculo fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_calculo
      @objeto = TarCalculo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tar_calculo_params
      params.require(:tar_calculo).permit(:clnt_id, :ownr_clss, :ownr_id, :tar_pago_id, :moneda, :monto, :glosa, :cuantia)
    end
end
