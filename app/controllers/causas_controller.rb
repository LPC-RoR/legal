class CausasController < ApplicationController
  before_action :set_causa, only: %i[ show edit update destroy cambio_estado procesa_registros actualiza_pago actualiza_antecedente ]

  include Tarifas

  # GET /causas or /causas.json
  def index
      # Causas
      init_tabla('ingreso-causas', Causa.where(estado: 'ingreso').order(created_at: :desc), false)
      add_tabla('proceso-causas', Causa.where(estado: 'proceso').order(created_at: :desc), false)
      add_tabla('terminada-causas', Causa.where(estado: 'terminada').order(created_at: :desc), true)
  end

  # GET /causas/1 or /causas/1.json
  def show

    init_tab( { menu: ['Antecedentes', 'Facturacion', 'Registro', 'Reportes'] }, true )

    if @options[:menu] == 'Antecedentes'
      init_tabla('tar_valor_cuantias', @objeto.valores_cuantia, false)
      add_tabla('antecedentes', @objeto.antecedentes.order(:orden), false)
    elsif @options[:menu] == 'Facturacion'
      init_tabla('tar_valor_cuantias', @objeto.valores_cuantia, false)
      add_tabla('tar_facturaciones', @objeto.facturaciones, false)
      add_tabla('tar_uf_facturaciones', @objeto.uf_facturaciones, false)
    elsif @options[:menu] == 'Documentos y enlaces'
      AppRepositorio.create(app_repositorio: @objeto.causa, owner_class: 'Causa', owner_id: @objeto.id) if @objeto.repositorio.blank?

      init_tabla('app_directorios', @objeto.repositorio.directorios, false)
      add_tabla('app_documentos', @objeto.repositorio.documentos, false)
      add_tabla('app_archivos', @objeto.repositorio.archivos, false)
      add_tabla('app_enlaces', @objeto.enlaces.order(:descripcion), false)
    elsif @options[:menu] == 'Registro'
      init_tabla('registros', @objeto.registros, false)
      @coleccion['registros'] = @coleccion['registros'].order(fecha: :desc) unless @coleccion['registros'].blank?
    elsif @options[:menu] == 'Reportes'
      init_tabla('reg_reportes', @objeto.reportes, false)
      @coleccion['reg_reportes'] = @coleccion['reg_reportes'].order(annio: :desc, mes: :desc) unless @coleccion['reg_reportes'].blank?
    end

  end

  # GET /causas/new
  def new
    modelo_causa = StModelo.find_by(st_modelo: 'Causa')
    @objeto = Causa.new(estado: modelo_causa.primer_estado.st_estado)
  end

  # GET /causas/1/edit
  def edit
  end

  # POST /causas or /causas.json
  def create
    @objeto = Causa.new(causa_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Causa fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /causas/1 or /causas/1.json
  def update
    respond_to do |format|
      if @objeto.update(causa_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Causa fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def cambio_estado
    StLog.create(perfil_id: current_usuario.id, class_name: @objeto.class.name, objeto_id: @objeto.id, e_origen: @objeto.estado, e_destino: params[:st])

    @objeto.estado = params[:st]
    @objeto.save

#    redirect_to "/st_bandejas?m=#{@objeto.class.name}&e=#{@objeto.estado}"
    redirect_to "/causas/#{@objeto.id}"
  end

  def procesa_registros
    registros_proceso = @objeto.registros.where(estado: 'ingreso')
    unless registros_proceso.empty?
      registros_proceso.each do |registro|
        reporte_mes = @objeto.reportes.where(annio: registro.fecha.year).find_by(mes: registro.fecha.month) unless @objeto.reportes.blank?
        reporte_mes = RegReporte.new(owner_class: 'Causa', owner_id: @objeto.id, annio: registro.fecha.year, mes: registro.fecha.month) if (reporte_mes.blank? or @objeto.reportes.empty?)
        reporte_mes.save

        registro.estado = 'reportado'
        registro.reg_reporte_id = reporte_mes.id
        registro.save
      end
    end

    redirect_to "/causas/#{@objeto.id}?html_options[tab]=Reportes"
    
  end

  def actualiza_pago
    unless params[:monto_pagado][:monto].blank?
      @objeto.monto_pagado = params[:monto_pagado][:monto]
      @objeto.save
    end

    redirect_to "/st_bandejas?m=Causa&e=#{@objeto.estado}"
  end

  def actualiza_antecedente
    unless params[:tag].blank?
      case params[:tag]
      when 'demandante'
        @objeto.demandante = params[:form_antecedente][params[:tag].to_sym]
      when 'cargo'
        @objeto.cargo = params[:form_antecedente][params[:tag].to_sym]
      when 'sucursal'
        @objeto.sucursal = params[:form_antecedente][params[:tag].to_sym]
      when 'abogados'
        @objeto.abogados = params[:form_antecedente][params[:tag].to_sym]
      end
      @objeto.save
    end

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Antecedentes"
  end

  # DELETE /causas/1 or /causas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Causa fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_causa
      @objeto = Causa.find(params[:id])
    end

    def set_redireccion
      @redireccion = causas_path
    end

    # Only allow a list of trusted parameters through.
    def causa_params
      params.require(:causa).permit(:causa, :identificador, :cliente_id, :estado, :juzgado_id, :rol, :era, :fecha_ingreso, :caratulado, :ubicacion, :fecha_ubicacion, :tribunal_corte_id, :rit, :estado_causa, :tipo_causa_id, :fecha_uf, :monto_pagado)
    end
end
