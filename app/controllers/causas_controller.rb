class CausasController < ApplicationController
  before_action :set_causa, only: %i[ show edit update destroy cambio_estado procesa_registros actualiza_pago agrega_valor elimina_valor input_tar_facturacion elimina_uf_facturacion traer_archivos_cuantia crea_archivo_controlado input_nuevo_archivo set_flags cuantia_to_xlsx nueva_materia nuevo_hecho hchstowrd ntcdntstowrd ]
  after_action :asigna_tarifa_defecto, only: %i[ create ]

  include Tarifas

  respond_to :docx

  # GET /causas or /causas.json
  def index
    @modelo = StModelo.find_by(st_modelo: 'Causa')
    @estados = @modelo.blank? ? [] : @modelo.st_estados.order(:orden).map {|e_ase| e_ase.st_estado}
    @tipos = nil
    @tipo = nil
    @estado = params[:e].blank? ? @estados[0] : params[:e]
    @path = "/causas?"
    @link_new = @estado == 'tramitación' ? causas_path : nil

    if params[:query].blank?
      coleccion = Causa.where(estado: @estado).order(created_at: :desc)
      set_tabla('causas', coleccion, true)
      @srch = false
    else
      @cs_array = Causa.search_for(params[:query])
      @srch = true
    end

  end

  def hchstowrd
    respond_with(@object, filename: 'hechos.docx', word_template: 'hchstowrd.docx')
  end

  def ntcdntstowrd
    respond_with(@object, filename: 'antecedentes.docx', word_template: 'ntcdntstowrd.docx')
  end

  # GET /causas/1 or /causas/1.json
  def show

    set_st_estado(@objeto)

    set_tab( :menu, ['Agenda', ['Hechos', operacion?], ['Tarifa & Pagos', finanzas?], ['Datos & Cuantía', operacion?], ['Documentos', operacion?]] )

    # Prueba de Docsplit

    case @options[:menu]
    when 'Agenda'
      @hoy = Time.zone.today

      set_tabla('age_actividades', @objeto.actividades.order(fecha: :desc), false)

      @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

      actividades_causa = @objeto.actividades.where(tipo: 'Audiencia').map {|act| act.age_actividad}
      @audiencias_pendientes = @objeto.tipo_causa.audiencias.map {|audiencia| audiencia.audiencia unless (audiencia.tipo == 'Única' and actividades_causa.include?(audiencia.audiencia))}.compact
    when 'Hechos'
      set_tabla('temas', @objeto.temas.order(:orden), false)
      set_tabla('hechos', @objeto.hechos.where(tema_id: nil).order(:orden), false)
      set_tabla('app_archivos', @objeto.app_archivos.order(:app_archivo), false)
    when 'Datos & Cuantía'
      # no se usa esta tabla, quizá luego se use para evitar proceso en vista
      set_tabla('tar_valor_cuantias', @objeto.valores_cuantia, false)

      vrbls_ids = @objeto.cliente.variables.ids.intersection(@objeto.tipo_causa.variables.ids)
      @variables = Variable.where(id: vrbls_ids)
      @valores = @objeto.valores_datos

      set_detalle_cuantia(@objeto, porcentaje_cuantia: false)
      @arry_cnt = array_cuantia(@objeto, @valores_cuantia)

      # @cuantia_tarifa {true, false} señala cuando la tarifa requiere la cuantía para su cálculo
      @cuantia_tarifa = @objeto.tar_tarifa.blank? ? false : @objeto.tar_tarifa.cuantia_tarifa
      @tarifa_requiere_cuantia = @objeto.tar_tarifa.blank? ? false : @objeto.tar_tarifa.cuantia_tarifa

      @audiencia_preparatoria = @objeto.actividades.find_by(age_actividad: 'Audiencia preparatoria')
    when 'Tarifa & Pagos'

#      set_tabla('tar_uf_facturaciones', @objeto.uf_facturaciones, false)
#      set_tabla('tar_facturaciones', @objeto.facturaciones, false)

      @pgs_stts = @objeto.tar_tarifa.blank? ? [] : pgs_stts(@objeto, @objeto.tar_tarifa)

      # Tarifas para seleccionar
      @tar_generales = TarTarifa.where(owner_id: nil).order(:tarifa)
      @tar_cliente = @objeto.tarifas_cliente.order(:tarifa)

    when 'Documentos'
      set_tabla('app_documentos', @objeto.documentos.order(:app_documento), false)
      set_tabla('app_archivos', @objeto.archivos.order(:app_archivo), false)
      set_tabla('app_enlaces', @objeto.enlaces.order(:descripcion), false)

      @d_pendientes = @objeto.documentos_pendientes
      @a_pendientes = @objeto.archivos_pendientes
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

  def cuantia_to_xlsx
    require 'axlsx'

    set_detalle_cuantia(@objeto, porcentaje_cuantia: false)
    arry_cnt = array_cuantia(@objeto, @valores_cuantia)

    caratula = "#{@objeto.rit} #{@objeto.causa}"
    remuneracion = @objeto.get_valor('Remuneración')
    audiencia_preparatoria = @objeto.get_age_actividad('Audiencia preparatoria')
    fecha_ap = audiencia_preparatoria.fecha

    planilla = Axlsx::Package.new
    wb = planilla.workbook

    wb.add_worksheet(name: 'Cuantía') do |sheet|
      sheet.add_row ['Causa', caratula]
      sheet.add_row ['Remuneración', remuneracion]
      sheet.add_row ['Audiencia preparatoria', fecha_ap]
      sheet.add_row ['Detalle de la cuantía']
      sheet.add_row ['Item', 'Honorarios', 'Real']
      @objeto.valores_cuantia.each do |vc|
        sheet.add_row [vc.detalle, vlr_tarifa(vc), vlr_cuantia(vc, 'real')]
      end
      sheet.add_row ['Total', total_cuantia(@objeto, 'tarifa'), total_cuantia(@objeto, 'real')]
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
    @objeto.valores_cuantia.each do |valor_cuantia|
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

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Tarifa+%26+Pagos"
  end

  def agrega_valor
    variable = Variable.find(params[:vid])

    valor = @objeto.valores_datos.find_by(variable_id: variable.id)

    case variable.tipo
    when 'Texto'
      if valor.blank?
        Valor.create(owner_class: 'Causa', owner_id: @objeto.id, variable_id: variable.id, c_string: params[:form_valor][:c_texto])
      else
        valor.c_string = params[:form_valor][:c_texto]
      end
    when 'Párrafo'
      if valor.blank?
        Valor.create(owner_class: 'Causa', owner_id: @objeto.id, variable_id: variable.id, c_parrafo: params[:form_valor][:c_parrafo])
      else
        valor.c_parrafo = params[:form_valor][:c_parrafo]
      end
    else
      if ['Número', 'Monto pesos', 'Monto UF'].include?(variable.tipo)
        if valor.blank?
          Valor.create(owner_class: 'Causa', owner_id: @objeto.id, variable_id: variable.id, c_numero: params[:form_valor][:c_numero])
        else
          valor.c_numero = params[:form_valor][:c_numero].to_f 
        end
      end
    end

    valor.save unless valor.blank?

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Datos+%26+Cuantía"
  end

  def elimina_valor
    variable = Variable.find(params[:vid])
    unless variable.blank?
      valor = @objeto.valores_datos.find_by(variable_id: variable.id)
      valor.delete unless valor.blank?
    end

    redirect_to "/causas/#{@objeto.owner.id}?html_options[menu]=#{CGI.escape('Datos & Cuantía')}"
  end

  # Manegos de TarUfFacturacion
  def input_tar_facturacion
    unless params[:form_tar_facturacion]['fecha_uf(1i)'].blank? or params[:form_tar_facturacion]['fecha_uf(2i)'].blank? or params[:form_tar_facturacion]['fecha_uf(3i)'].blank?
      tar_pago = TarPago.find(params[:pid])
      unless tar_pago.blank?
        tar_uf_facturacion = @objeto.tar_uf_facturacion(tar_pago)
        annio = params[:form_tar_facturacion]['fecha_uf(1i)'].to_i
        mes = params[:form_tar_facturacion]['fecha_uf(2i)'].to_i
        dia = params[:form_tar_facturacion]['fecha_uf(3i)'].to_i

        if tar_uf_facturacion.blank?
          tar_uf_facturacion = TarUfFacturacion.create( owner_class: 'Causa', owner_id: @objeto.id, tar_pago_id: tar_pago.id )
        end
        tar_uf_facturacion.fecha_uf = Time.zone.parse("#{annio}-#{mes}-#{dia}")
        tar_uf_facturacion.save
      end
    end

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Tarifa+%26+Pagos"
  end

  def elimina_uf_facturacion
    tar_pago = TarPago.find(params[:pid])
    tar_uf_facturacion = @objeto.tar_uf_facturacion(tar_pago)
    tar_uf_facturacion.delete

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Tarifa+%26+Pagos"
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
      tarifas = etapa.blank? ? [] : @objeto.cliente.tarifas.where(tipo_causa_id: etapa.id)
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
      @redireccion = causas_path
    end

    # Only allow a list of trusted parameters through.
    def causa_params
      params.require(:causa).permit(:causa, :identificador, :cliente_id, :estado, :juzgado_id, :rol, :era, :fecha_ingreso, :caratulado, :ubicacion, :fecha_ubicacion, :tribunal_corte_id, :rit, :estado_causa, :tipo_causa_id, :fecha_uf, :monto_pagado, :query)
    end
end
