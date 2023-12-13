class CausasController < ApplicationController
  before_action :set_causa, only: %i[ show edit update destroy cambio_estado procesa_registros actualiza_pago actualiza_antecedente crea_documento_controlado crea_archivo_controlado]

  include Tarifas

  # GET /causas or /causas.json
  def index
    set_tab( :monitor,  ['Proceso', 'Terminadas'] )

    if @moptions[:monitor] == 'Proceso'
      init_tabla('ingreso-causas', Causa.where(estado: 'ingreso').order(created_at: :desc), false)
      add_tabla('proceso-causas', Causa.where(estado: 'proceso').order(created_at: :desc), false)
    elsif @moptions[:monitor] == 'Terminadas'
      init_tabla('terminada-causas', Causa.where(estado: 'terminada').order(created_at: :desc), true)
    end
  end

  # GET /causas/1 or /causas/1.json
  def show

    init_tab( { menu: ['Seguimiento', 'Tarifa & Cuantía', 'Pagos', 'Registro', 'Reportes'] }, true )

    if @options[:menu] == 'Seguimiento'
      init_tabla('tar_facturaciones', @objeto.facturaciones, false)

      add_tabla('app_documentos', @objeto.documentos.order(:app_documento), false)
      add_tabla('app_archivos', @objeto.archivos.order(:app_archivo), false)
      add_tabla('audiencia-age_actividades', @objeto.actividades.where(tipo: 'Audiencia').order(fecha: :desc), false)
      add_tabla('reunion-age_actividades', @objeto.actividades.where(tipo: 'Reunión').order(fecha: :desc), false)
      add_tabla('tarea-age_actividades', @objeto.actividades.where(tipo: 'Tarea').order(fecha: :desc), false)

      @docs_pendientes =  @objeto.exclude_docs - @objeto.documentos.map {|doc| doc.app_documento}
      @archivos_pendientes =  @objeto.exclude_files - @objeto.archivos.map {|archivo| archivo.app_archivo}

      actividades_causa = @objeto.actividades.where(tipo: 'Audiencia').map {|act| act.age_actividad}
      @audiencias_pendientes = @objeto.tipo_causa.audiencias.map {|audiencia| audiencia.audiencia unless (audiencia.tipo == 'Única' and actividades_causa.include?(audiencia.audiencia))}.compact
    elsif @options[:menu] == 'Tarifa & Cuantía'
      init_tabla('tar_valor_cuantias', @objeto.valores_cuantia, false)
      # Tarifas para seleccionar
      @tar_generales = TarTarifa.where(owner_id: nil).order(:tarifa)
      @tar_cliente = @objeto.tarifas_cliente.order(:tarifa)
    elsif @options[:menu] == 'Pagos'
      init_tabla('tar_uf_facturaciones', @objeto.uf_facturaciones, false)
    elsif @options[:menu] == 'Antecedentes'
      init_tabla('tar_valor_cuantias', @objeto.valores_cuantia, false)
      add_tabla('antecedentes', @objeto.antecedentes.order(:orden), false)
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

  # se utiliza para Clases que manejan estados porque se declaró el modelo
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

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Facturacion"
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

  def crea_documento_controlado
    st_modelo = StModelo.find_by(st_modelo: @objeto.class.name)
    unless st_modelo.blank?
      control = st_modelo.control_documentos.find_by(nombre: params[:indice])
      unless control.blank? 
        AppDocumento.create(owner_class: @objeto.class.name, owner_id: @objeto.id, app_documento: control.nombre, existencia: control.control, documento_control: true)
      end
    end

    redirect_to @objeto
  end

  def crea_archivo_controlado
    st_modelo = StModelo.find_by(st_modelo: @objeto.class.name)
    unless st_modelo.blank?
      control = st_modelo.control_documentos.find_by(nombre: params[:indice])
      unless control.blank? 
        AppArchivo.create(owner_class: @objeto.class.name, owner_id: @objeto.id, app_archivo: control.nombre, control: control.control, documento_control: true)
      end
    end

    redirect_to @objeto
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
