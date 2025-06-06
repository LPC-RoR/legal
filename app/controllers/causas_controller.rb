class CausasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_causa, only: %i[ show edit update destroy asigna_tarifa cambio_estado rsltd estmcn procesa_registros add_uf_facturacion del_uf_facturacion traer_archivos_cuantia crea_archivo_controlado input_nuevo_archivo set_flags cuantia_to_xlsx nueva_materia nuevo_hecho hchstowrd ntcdntstowrd ]
  after_action :asigna_tarifa_defecto, only: %i[ create ]

  include Tarifas

  respond_to :docx

  # GET /causas or /causas.json
  def index
    # Usuarios que no tienen ownr
    @age_usuarios = AgeUsuario.no_ownr

    scp = params[:scp].blank? ? 'trmtcn' : params[:scp]

    @scp = scp_item[:causas][scp.to_sym]

    if params[:query].present?
      cllcn = Causa.search_for(params[:query])
    else
      case scp
      when 'trmtcn'
        cllcn = Causa.std('tramitación')
      when 'sn_fctrcn'
        cllcn = Causa.no_fctrds
      when 'trmnds'
        cllcn = Causa.std('terminada')
      when 'crrds'
        cllcn = Causa.std('cerrada')
      when 'en_rvsn'
        cllcn = Causa.std('revisión')
      end
    end

    set_tabla('causas', cllcn, true)

  end

  def hchstowrd
    respond_with(@objeto, filename: 'hechos.docx', word_template: 'hchstowrd.docx')
  end

  def ntcdntstowrd
    respond_with(@objeto, filename: 'antecedentes.docx', word_template: 'ntcdntstowrd.docx')
  end

  # GET /causas/1 or /causas/1.json
  def show

    set_st_estado(@objeto)
    set_tab( :menu, ['General', ['Hechos', operacion?], ['Tarifa & Pagos', finanzas?], ['Demanda', dog?]] )

    # Prueba de Docsplit

    case @options[:menu]
    when 'General'
      @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)
      @actividades = @objeto.age_actividades.map {|act| act.age_actividad}

      set_tabla('age_actividades', @objeto.age_actividades.fecha_ordr, false)
      set_tabla('notas', @objeto.notas.rlzds, false)
      set_tabla('monto_conciliaciones', @objeto.monto_conciliaciones.ordr_fecha, false)
      set_tabla('estados', @objeto.estados.ordr_dfecha, false)
      set_tabla('app_archivos', @objeto.as, false)

    when 'Hechos'
      set_tabla('temas', @objeto.temas.order(:orden), false)
      set_tabla('hechos', @objeto.hechos.where(tema_id: nil).order(:orden), false)
      set_tabla('rep_archivos', @objeto.rep_archivos.ordr, false)
    when 'Tarifa & Pagos'

      set_tabla('tar_uf_facturaciones', @objeto.uf_facturaciones, false)
      set_tabla('tar_facturaciones', @objeto.tar_facturaciones, false)

      @pgs_stts = @objeto.tar_tarifa.blank? ? [] : pgs_stts(@objeto)

      # Tarifas para seleccionar
      @tar_generales = TarTarifa.where(ownr_id: nil).order(:tarifa)
      @tar_cliente = @objeto.tarifas_cliente.order(:tarifa)

    when 'Demanda'
      set_tabla('parrafos', @objeto.parrafos.order(:orden), false)
    when 'Registro'
      set_tabla('registros', @objeto.registros, false)
      @coleccion['registros'] = @coleccion['registros'].order(fecha: :desc) unless @coleccion['registros'].blank?
    when 'Reportes'
      set_tabla('reg_reportes', @objeto.reportes, false)
      @coleccion['reg_reportes'] = @coleccion['reg_reportes'].order(annio: :desc, mes: :desc) unless @coleccion['reg_reportes'].blank?
    end

  end

  # GET /causas/new
  def new
    modelo_causa = StModelo.get_model('Causa')
    @objeto = Causa.new(estado: modelo_causa.primer_estado.st_estado, urgente: false, pendiente: false)
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

  def cuantia_to_xlsx
    require 'axlsx'

    caratula = "#{@objeto.rit} #{@objeto.causa}"
    remuneracion = 0 # @objeto.get_valor('Remuneración')
    audiencia_preparatoria = @objeto.get_age_actividad('Audiencia preparatoria')
    fecha_ap = audiencia_preparatoria.blank? ? 'sin fecha' : audiencia_preparatoria.fecha

    planilla = Axlsx::Package.new
    wb = planilla.workbook

    wb.add_worksheet(name: 'Cuantía') do |sheet|
      sheet.add_row ['Causa', caratula]
#      sheet.add_row ['Remuneración', remuneracion]
      sheet.add_row ['Audiencia preparatoria', fecha_ap]
      sheet.add_row ['Detalle de la cuantía']
      sheet.add_row ['Item', 'Honorarios', 'Real']
      @objeto.tar_valor_cuantias.each do |vc|
        sheet.add_row [vc.detalle, vlr_tarifa(vc), vlr_cuantia(vc, 'real')]
      end
      sheet.add_row ['Total', get_total_cuantia(@objeto, 'tarifa'), get_total_cuantia(@objeto, 'real')]
    end

    #    planilla.serialize 'cuantia.xlsx'
    send_data planilla.to_stream.read, type: "application/xlsx", filename: "#{caratula}.xlsx"

    #redirect_to "/causas/#{@objeto.id}"    
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

  def asigna_tarifa
    @objeto.tar_tarifa_id = params[:oid] == 'nil' ? nil : params[:oid]
    @objeto.save

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=#{prm_safe('Tarifa & Pagos')}"
  end

  def rsltd
    @objeto.resultado = params[:rsltd][:resultado]
    @objeto.save

    redirect_to "/servicios/auditoria?oid=#{@objeto.cliente.id}"
  end

  def estmcn
    @objeto.probabilidad = params[:estmcn][:probabilidad]
    @objeto.potencial_perdida = params[:estmcn][:potencial_perdida]
    @objeto.estimacion = params[:estmcn][:estimacion]
    @objeto.save

    redirect_to "/servicios/auditoria?oid=#{@objeto.cliente.id}"
  end

  def nueva_materia
    f_prms = params[:nueva_materia]
    unless f_prms[:tema].blank?
      n_materias = @objeto.temas.count
      @objeto.temas.create(tema: f_prms[:tema], orden: n_materias + 1)
    end

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Hechos"
  end

  def nuevo_hecho
    f_prms = params[:nuevo_hecho]
    unless f_prms[:descripcion].blank?
      n_hechos = @objeto.hechos.count
      @objeto.hechos.create(hecho: f_prms[:hecho], descripcion: f_prms[:descripcion], orden: n_hechos + 1)
    end

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Hechos"
  end

  def set_flags
    case params[:f]
    when 'hreg'
      @objeto.hechos_registrados = @objeto.hechos_registrados ? false : true
    when 'areg'
      @objeto.archivos_registrados = @objeto.archivos_registrados ? false : true
    end
    @objeto.save

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Hechos"
  end

  def traer_archivos_cuantia
    controlados = @objeto.app_archivos.map { |app_a| app_a.app_archivo }
    @objeto.tar_valor_cuantias.each do |valor_cuantia|
      valor_cuantia.tar_detalle_cuantia.control_documentos.each do |control|
        unless controlados.include?(control.nombre)
          controlados << control.nombre
          app_archivo = AppArchivo.create(owner_class: nil, owner_id: nil, app_archivo: control.nombre, control: control.control, documento_control: true)
          @objeto.causa_archivos.create(app_archivo_id: app_archivo.id, orden: @objeto.causa_archivos.count + 1)
        end
      end
    end

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Hechos"
  end

  def crea_archivo_controlado
    control = ControlDocumento.find(params[:cid])
    controlados = @objeto.app_archivos.map { |app_a| app_a.app_archivo }
    unless controlados.include?(control.nombre)
      app_archivo = AppArchivo.create(owner_class: nil, owner_id: nil, app_archivo: control.nombre, control: control.control, documento_control: true)
      @objeto.causa_archivos.create(app_archivo_id: app_archivo.id, orden: @objeto.causa_archivos.count + 1)
    end

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Hechos"
  end

  def input_nuevo_archivo
    f_params = params[:nuevo_archivo]
    unless f_params[:app_archivo].blank?
      app_archivo = AppArchivo.create(owner_class: nil, owner_id: nil, app_archivo: f_params[:app_archivo], control: nil, documento_control: false)
      @objeto.causa_archivos.create(app_archivo_id: app_archivo.id, orden: @objeto.causa_archivos.count + 1)
    end

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Hechos"
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

  # Manegos de TarUfFacturacion
  def add_uf_facturacion
    prms = params[:form_uf_facturacion]
    unless prms['fecha_uf(1i)'].blank? or prms['fecha_uf(2i)'].blank? or prms['fecha_uf(3i)'].blank?
      tar_pago = TarPago.find(params[:pid])
      unless tar_pago.blank?
        tar_uf_facturacion = @objeto.tar_uf_facturacion(tar_pago)
        fecha_uf = prms_to_date_raw(prms, 'fecha_uf')

        if tar_uf_facturacion.blank?
          tar_uf_facturacion = TarUfFacturacion.create( ownr_type: 'Causa', ownr_id: @objeto.id, tar_pago_id: tar_pago.id )
        end
        tar_uf_facturacion.fecha_uf = fecha_uf
        tar_uf_facturacion.save
      end
    end

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=#{CGI.escape('Tarifa & Pagos')}"
  end

  def del_uf_facturacion
    tar_pago = TarPago.find(params[:pid])
    tar_uf_facturacion = @objeto.tar_uf_facturacion(tar_pago)
    tar_uf_facturacion.delete

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=#{CGI.escape('Tarifa & Pagos')}"
  end

  # se utiliza para Clases que manejan estados porque se declaró el modelo
  def cambio_estado
    StLog.create(perfil_id: current_usuario.id, class_name: @objeto.class.name, objeto_id: @objeto.id, e_origen: @objeto.estado, e_destino: params[:st])

    @objeto.estado = params[:st]
    @objeto.save

#    redirect_to "/st_bandejas?m=#{@objeto.class.name}&e=#{@objeto.estado}"
    redirect_to "/causas/#{@objeto.id}"
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

    def asigna_tarifa_defecto
      etapa = @objeto.tipo_causa
      tarifas = etapa.blank? ? [] : @objeto.cliente.tar_tarifas.where(tipo_causa_id: etapa.id)
      tarifa = tarifas.empty? ? nil : tarifas.first

      unless tarifa.blank?
        @objeto.tar_tarifa_id = tarifa.id
        @objeto.save
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_causa
      @objeto = Causa.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/causas#cid_#{@objeto.id}"
    end

    # Only allow a list of trusted parameters through.
    def causa_params
      params.require(:causa).permit(:causa, :identificador, :cliente_id, :estado, :juzgado_id, :rol, :era, :fecha_ingreso, :caratulado, :ubicacion, :fecha_ubicacion, :tribunal_corte_id, :rit, :estado_causa, :tipo_causa_id, :fecha_uf, :monto_pagado, :query, :urgente, :pendiente, :en_cobranza)
    end
end
