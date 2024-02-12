class ClientesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :set_cliente, only: %i[ show edit update destroy cambio_estado crea_factura aprueba_factura crea_documento_controlado crea_archivo_controlado ]
  after_action :rut_puro, only: %i[ create update ]

#  include Bandejas

  # GET /clientes or /clientes.json
  def index

    set_tab( :menu, ['Proceso', 'Baja'] )

    if @options[:menu] == 'Proceso'
      set_tabla('ingreso-clientes', Cliente.where(estado: 'ingreso').order(:razon_social), false)
      set_tabla('activo_empresa-clientes', Cliente.where(estado: 'activo', tipo_cliente: 'Empresa').order(:razon_social), false)
      set_tabla('activo_sindicato-clientes', Cliente.where(estado: 'activo', tipo_cliente: 'Sindicato').order(:razon_social), false)
      set_tabla('activo_trabajador-clientes', Cliente.where(estado: 'activo', tipo_cliente: 'Trabajador').order(:razon_social), false)
    elsif @options[:menu] == 'Baja'
      set_tabla('baja-clientes', Cliente.where(estado: 'baja').order(:razon_social), true)
    end
  end

  # GET /clientes/1 or /clientes/1.json
  def show

    set_tab( :menu, ['Seguimiento', 'Causas', 'Asesorias', 'Facturas', 'Tarifas'] )

#    @coleccion = {}
    if @options[:menu] == 'Seguimiento'

      @hoy = Time.zone.today

      set_tabla('age_actividades', @objeto.actividades.order(fecha: :desc), false)

      @age_usuarios = AgeUsuario.where(owner_class: '', owner_id: nil)

      set_tabla('app_documentos', @objeto.documentos.order(:app_documento), false)
      set_tabla('app_archivos', @objeto.archivos.order(:app_archivo), false)

      @docs_pendientes =  @objeto.exclude_docs - @objeto.documentos.map {|doc| doc.app_documento}
      @archivos_pendientes =  @objeto.exclude_files - @objeto.archivos.map {|archivo| archivo.app_archivo}
    elsif @options[:menu] == 'Causas'
      set_tab( :monitor,  ['Proceso', 'Terminadas'] )
      causas_cliente = @objeto.causas
      set_tabla('ingreso-causas', causas_cliente.where(estado: 'ingreso').order(:created_at), false)
      set_tabla('proceso-causas', causas_cliente.where(estado: 'proceso').order(:created_at), false)
      set_tabla('terminada-causas', causas_cliente.where(estado: 'terminada').order(:created_at), true)

    elsif @options[:menu] == 'Asesorias'
      set_tab( :monitor,  ['Proceso', 'Terminadas', 'Multas & Redacciones', 'Mensuales & Cargos'] )
      asesorias_cliente = @objeto.asesorias

      if @options[:monitor] == 'Proceso'
        set_tabla('ingreso-asesorias', asesorias_cliente.where(estado: 'ingreso').order(created_at: :desc), false)
        set_tabla('proceso-asesorias', asesorias_cliente.where(estado: 'proceso').order(created_at: :desc), false)
      elsif @options[:monitor] == 'Terminadas'
        set_tabla('terminada-asesorias', asesorias_cliente.where(estado: 'terminada').order(created_at: :desc), true)
      elsif @options[:monitor] == 'Multas & Redacciones'
        ta_multas = TipoAsesoria.find_by(tipo_asesoria: 'Multa')
        ta_redacciones = TipoAsesoria.find_by(tipo_asesoria: 'Redacción')

        set_tabla('multas-asesorias', asesorias_cliente.where(tipo_asesoria_id: ta_multas.id ,estado: 'terminada').order(created_at: :desc), false)
        set_tabla('redacciones-asesorias', asesorias_cliente.where(tipo_asesoria_id: ta_redacciones.id ,estado: 'terminada').order(created_at: :desc), false)
      elsif @options[:monitor] == 'Mensuales & Cargos'
        ta_mensuales = TipoAsesoria.find_by(tipo_asesoria: 'Mensual')
        ta_cargos = TipoAsesoria.find_by(tipo_asesoria: 'Cargo')

        set_tabla('mensuales-asesorias', asesorias_cliente.where(tipo_asesoria_id: ta_mensuales.id ,estado: 'terminada').order(created_at: :desc), false)
        set_tabla('cargos-asesorias', asesorias_cliente.where(tipo_asesoria_id: ta_cargos.id ,estado: 'terminada').order(created_at: :desc), false)
      end

    elsif @options[:menu] == 'Facturas'
      set_tab( :monitor,  ['Proceso', 'Pagadas'] )
      facturas_cliente = @objeto.facturas
      set_tabla('ingreso-tar_facturas', facturas_cliente.where(estado: 'ingreso').order(documento: :desc), false)
      set_tabla('facturada-tar_facturas', facturas_cliente.where(estado: 'facturada').order(documento: :desc), false)
      set_tabla('pagada-tar_facturas', facturas_cliente.where(estado: 'pagada').order(documento: :desc), true)
    elsif @options[:menu] == 'Tarifas'
      set_tabla('tar_tarifas', @objeto.tarifas.order(:created_at), false)
      set_tabla('tar_servicios', @objeto.servicios.order(:created_at), false)
    elsif @options[:menu] == 'Documentos y enlaces'
      @repositorio = AppRepositorio.where(owner_class: 'Cliente').find_by(owner_id: @objeto.id)
      @repositorio = AppRepositorio.create(app_repositorio: @objeto.razon_social, owner_class: 'Cliente', owner_id: @objeto.id) if @repositorio.blank?
      set_tabla('app_directorios', @repositorio.directorios, false)
      set_tabla('app_documentos', @repositorio.documentos, false)
      set_tabla('app_archivos', @repositorio.archivos, false)
    end

  end

  # GET /clientes/new
  def new
    modelo_cliente = StModelo.find_by(st_modelo: 'Cliente')
    @objeto = Cliente.new(estado: modelo_cliente.primer_estado.st_estado)
  end

  # GET /clientes/1/edit
  def edit
  end

  # POST /clientes or /clientes.json
  def create
    @objeto = Cliente.new(cliente_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Cliente fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clientes/1 or /clientes/1.json
  def update
    respond_to do |format|
      if @objeto.update(cliente_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Cliente fue exitósamente actualizado." }
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

    redirect_to "/clientes/#{@objeto.id}"
  end

  # DEPRECATED
  def crea_factura
    concepto = (@objeto.facturacion_pendiente.count == 1 ? @objeto.facturacion_pendiente.first.glosa : "Varios de cliente #{@objeto.razon_social}")
    factura = TarFactura.create(concepto: concepto, owner_class: 'Cliente', owner_id: @objeto.id, estado: 'ingreso',fecha_factura: Time.zone.today.to_date)

    @objeto.facturacion_pendiente.each do |facturacion|
      factura.tar_facturaciones << facturacion
    end

    redirect_to tar_facturas_path
  end

  #DEPRECATED
  def aprueba_factura
    factura = TarFactura.create(owner_class: @objeto.class.name, owner_id: @objeto.id, concepto: "Varios #{@objeto.razon_social}", fecha_factura: Time.zone.today.to_date, estado: 'ingreso')
    
    @objeto.aprobaciones.each do |aprobacion|
      aprobacion.estado = 'aprobado'
      aprobacion.save
      factura.tar_facturaciones << aprobacion
    end

    redirect_to factura
  end

  def crea_documento_controlado
    st_modelo = StModelo.find_by(st_modelo: 'Cliente')
    unless st_modelo.blank?
      control = st_modelo.control_documentos.find_by(nombre: params[:indice])
      unless control.blank? 
        AppDocumento.create(owner_class: 'Cliente', owner_id: @objeto.id, app_documento: control.nombre, existencia: control.control, documento_control: true)
      end
    end

    redirect_to @objeto
  end

  def crea_archivo_controlado
    st_modelo = StModelo.find_by(st_modelo: 'Cliente')
    unless st_modelo.blank?
      control = st_modelo.control_documentos.find_by(nombre: params[:indice])
      unless control.blank? 
        AppArchivo.create(owner_class: 'Cliente', owner_id: @objeto.id, app_archivo: control.nombre, control: control.control, documento_control: true)
      end
    end

    redirect_to @objeto
  end

  # DELETE /clientes/1 or /clientes/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Cliente fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    def rut_puro
      @objeto.rut = @objeto.rut.gsub(' ', '').gsub('.', '').gsub('-', '')
      @objeto.save
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_cliente
      @objeto = Cliente.find(params[:id])
    end

    def set_redireccion
      @redireccion = clientes_path
    end

    # Only allow a list of trusted parameters through.
    def cliente_params
      params.require(:cliente).permit(:razon_social, :rut, :estado, :tipo_cliente)
    end
end
