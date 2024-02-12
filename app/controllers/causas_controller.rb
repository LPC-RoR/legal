class CausasController < ApplicationController
  before_action :set_causa, only: %i[ show edit update destroy cambio_estado procesa_registros actualiza_pago actualiza_antecedente crea_documento_controlado crea_archivo_controlado agrega_valor elimina_valor input_tar_facturacion elimina_uf_facturacion]

  include Tarifas

  # GET /causas or /causas.json
  def index
    set_tab( :monitor,  ['Proceso', 'Terminadas'] )

    if @options[:monitor] == 'Proceso'
      set_tabla('ingreso-causas', Causa.where(estado: 'ingreso').order(created_at: :desc), false)
      set_tabla('proceso-causas', Causa.where(estado: 'proceso').order(created_at: :desc), false)
    elsif @options[:monitor] == 'Terminadas'
      set_tabla('terminada-causas', Causa.where(estado: 'terminada').order(created_at: :desc), true)
    end
  end

  # GET /causas/1 or /causas/1.json
  def show

    set_tab( :menu, ['Seguimiento', 'Hechos', 'Tarifa & Pagos', 'Datos & Cuantía', 'Registro', 'Reportes'] )

    if @options[:menu] == 'Seguimiento'

      @hoy = Time.zone.today

      set_tabla('age_actividades', @objeto.actividades.order(fecha: :desc), false)

      set_tabla('app_documentos', @objeto.documentos.order(:app_documento), false)
      set_tabla('app_archivos', @objeto.archivos.order(:app_archivo), false)
      set_tabla('app_enlaces', @objeto.enlaces.order(:descripcion), false)

      @age_usuarios = AgeUsuario.where(owner_class: '', owner_id: nil)

      @docs_pendientes =  @objeto.exclude_docs - @objeto.documentos.map {|doc| doc.app_documento}
      @archivos_pendientes =  @objeto.exclude_files - @objeto.archivos.map {|archivo| archivo.app_archivo}

      actividades_causa = @objeto.actividades.where(tipo: 'Audiencia').map {|act| act.age_actividad}
      @audiencias_pendientes = @objeto.tipo_causa.audiencias.map {|audiencia| audiencia.audiencia unless (audiencia.tipo == 'Única' and actividades_causa.include?(audiencia.audiencia))}.compact
    elsif @options[:menu] == 'Hechos'
      set_tabla('temas', @objeto.temas.order(:orden), true)

      set_tabla('app_documentos', @objeto.app_documentos.order(:app_documento), false)
    elsif @options[:menu] == 'Datos & Cuantía'
      # no se usa esta tabla, quizá luego se use para evitar proceso en vista
      set_tabla('tar_valor_cuantias', @objeto.valores_cuantia, false)

      @variables = @objeto.tipo_causa.variables.order(:orden)
      @valores = @objeto.valores_datos

      set_detalle_cuantia(@objeto)

      # @cuantia_tarifa {treu, false} señala cuando la tarifa requiere la cuantía para su cálculo
      @cuantia_tarifa = @objeto.tar_tarifa.blank? ? false : @objeto.tar_tarifa.cuantia_tarifa
      @tarifa_requiere_cuantia = @objeto.tar_tarifa.blank? ? false : @objeto.tar_tarifa.cuantia_tarifa
    elsif @options[:menu] == 'Tarifa & Pagos'
      set_tabla('tar_uf_facturaciones', @objeto.uf_facturaciones, false)
      set_tabla('tar_facturaciones', @objeto.facturaciones, false)

      @h_pagos = get_h_pagos(@objeto)

      # Tarifas para seleccionar
      @tar_generales = TarTarifa.where(owner_id: nil).order(:tarifa)
      @tar_cliente = @objeto.tarifas_cliente.order(:tarifa)

      # PRUEBA, aún no se usan
      set_formulas(@objeto)
      @calc_valores = @objeto.set_valores
    elsif @options[:menu] == 'Antecedentes'
      set_tabla('tar_valor_cuantias', @objeto.valores_cuantia, false)
      set_tabla('antecedentes', @objeto.antecedentes.order(:orden), false)
    elsif @options[:menu] == 'Documentos y enlaces'
      AppRepositorio.create(app_repositorio: @objeto.causa, owner_class: 'Causa', owner_id: @objeto.id) if @objeto.repositorio.blank?

      set_tabla('app_directorios', @objeto.repositorio.directorios, false)
      set_tabla('app_documentos', @objeto.repositorio.documentos, false)
      set_tabla('app_archivos', @objeto.repositorio.archivos, false)
      set_tabla('app_enlaces', @objeto.enlaces.order(:descripcion), false)
    elsif @options[:menu] == 'Registro'
      set_tabla('registros', @objeto.registros, false)
      @coleccion['registros'] = @coleccion['registros'].order(fecha: :desc) unless @coleccion['registros'].blank?
    elsif @options[:menu] == 'Reportes'
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

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Tarifa+%26+Pagos"
  end

  # DEPRECATED ???
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
    control = @objeto.tipo_causa.control_documentos.find_by(nombre: params[:indice])
    unless control.blank? 
      AppDocumento.create(owner_class: @objeto.class.name, owner_id: @objeto.id, app_documento: control.nombre, existencia: control.control, documento_control: true)
    end

    redirect_to @objeto
  end

  def crea_archivo_controlado
    control = @objeto.tipo_causa.control_documentos.find_by(nombre: params[:indice])
    unless control.blank? 
      AppArchivo.create(owner_class: @objeto.class.name, owner_id: @objeto.id, app_archivo: control.nombre, control: control.control, documento_control: true)
    end

    redirect_to @objeto
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

    redirect_to "/causas/#{@objeto.id}?html_options[menu]=Datos+%26+Cuantía"
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

  # crea el array con el cálculo del pago
    def array_pago(causa, pago)
      pago_generado = causa.pago_generado(pago)
      uf_pago = causa.uf_calculo_pago(pago)
      if pago_generado.blank?
        monto = pago.valor.blank? ? calcula2(pago.formula_tarifa, causa, pago) : pago.valor
        monto_pesos = pago.moneda == 'Pesos' ? monto : ( uf_pago.blank? ? 0 : monto * uf_pago.valor )
        monto_uf = pago.moneda == 'UF' ? monto : ( uf_pago.blank? ? 0 : monto / uf_pago.valor )
      else
        monto_pesos = pago_generado.monto_pesos
        monto_uf = pago_generado.monto_uf
      end
      {
        pago: pago_generado,
        origen_fecha_pago: causa.origen_fecha_pago(pago),
        monto_pesos: monto_pesos,
        monto_uf: monto_uf
      }
    end

    # crea un hash con el cálculo de los pagos
    def get_h_pagos(causa)
      h_pagos = {}      
      unless causa.tar_tarifa.blank? or causa.tar_tarifa.tar_pagos.empty?
        causa.tar_tarifa.tar_pagos.order(:orden).each do |pago|
          h_pagos[pago.id] = array_pago(causa, pago)
        end
      end
      h_pagos
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
      params.require(:causa).permit(:causa, :identificador, :cliente_id, :estado, :juzgado_id, :rol, :era, :fecha_ingreso, :caratulado, :ubicacion, :fecha_ubicacion, :tribunal_corte_id, :rit, :estado_causa, :tipo_causa_id, :fecha_uf, :monto_pagado)
    end
end
