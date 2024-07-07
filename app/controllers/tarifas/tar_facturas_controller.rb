class Tarifas::TarFacturasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tar_factura, only: %i[ show edit update destroy elimina set_documento cambio_estado set_pago set_facturada libera_factura crea_nota_credito elimina_nota_credito a_facturada]

  include Tarifas

  # GET /tar_facturas or /tar_facturas.json
  def index
    @estados = StModelo.find_by(st_modelo: 'TarFactura').st_estados.order(:orden).map {|e_ase| e_ase.st_estado}
    @tipos = nil
    @tipo = nil
    @estado = params[:e].blank? ? @estados[0] : params[:e]
    @path = "/tar_facturas?"

    coleccion = TarFactura.where(estado: @estado).order(created_at: :desc)
    set_tabla('tar_facturas', coleccion, true)

  end

  # GET /tar_facturas/1 or /tar_facturas/1.json
  def show
    set_tabla('tar_facturaciones', @objeto.tar_facturaciones, false)
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
        format.html { redirect_to @objeto, notice: "Factura fue exitósamente creada." }
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
        format.html { redirect_to @objeto, notice: "Factura fue exitósamente actualizada." }
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
      @objeto.clave = @objeto.fecha_factura.year * 100 + @objeto.fecha_factura.month
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

  def libera_factura
    @objeto.tar_facturaciones.each do |facturacion|
      @objeto.tar_facturaciones.delete(facturacion)

      owner = facturacion.owner
      case owner.class.name
      when 'Causa'
        if owner.facturaciones.where.not(tar_factura_id: nil).count == owner.tar_tarifa.tar_pagos.count
          owner.estado = 'terminada'
        else
          owner.estado = 'proceso'
        end
        owner.save
      when 'Asesoria'
        owner.estado = 'terminada'
        owner.save
      end

    end
    @objeto.delete

    redirect_to tar_facturas_path
  end

  def crea_nota_credito
    numero = params[:tar_nota_credito][:numero]
    annio = params[:tar_nota_credito]['fecha(1i)'].to_i
    mes = params[:tar_nota_credito]['fecha(2i)'].to_i
    dia = params[:tar_nota_credito]['fecha(3i)'].to_i
    fecha = DateTime.new(annio, mes, dia, 0, 0)
    monto = params[:tar_nota_credito][:monto]
    monto_total = params[:tar_nota_credito][:monto_total]
    unless numero.blank? or fecha.blank? or (monto.blank? and monto_total == false)
      nc=TarNotaCredito.create(numero: numero, fecha: fecha, monto: monto, monto_total: monto_total, tar_factura_id: @objeto.id)
      if nc.blank?
        noticia = 'No se pudo crear Nota de crédito'
      else
        @objeto.tar_nota_credito = nc
        @objeto.estado = 'pagada'
        @objeto.save
        noticia = 'Nota de crédito fue exitósamente creada'
      end
    else
        noticia = 'Error al crear Nota de crédito: Información incompleta'
    end
    
    redirect_to @objeto, notice: noticia
  end

  def elimina_nota_credito
    nc = @objeto.tar_nota_credito
    nc.delete
    @objeto.estado = 'facturada'
    @objeto.save
    
    redirect_to @objeto, notice: 'Nota de crédito fue exitósamente eliminada'
  end

  def a_facturada
    registro = MRegistro.find(params[:oid])
    registro.tar_facturas.delete(@objeto)
    @objeto.estado = 'facturada'
    @objeto.save

    redirect_to registro, notice: 'factura liberada'
  end

  # DELETE /tar_facturas/1 or /tar_facturas/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to tar_facturas_url, notice: "Factura fue exitósamente eliminada." }
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
