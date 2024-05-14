class ClientesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :set_cliente, only: %i[ show edit update destroy cambio_estado crea_factura aprueba_factura ]
  after_action :rut_puro, only: %i[ create update ]

#  include Bandejas

  # GET /clientes or /clientes.json
  def index

    @estados = StModelo.find_by(st_modelo: 'Cliente').st_estados.order(:orden).map {|e_cli| e_cli.st_estado}
    @tipos = Cliente::TIPOS
    @tipo = params[:t]
    @estado = (params[:e].blank? and params[:t].blank?) ? @estados[0] : params[:e]
    @path = '/clientes'

    if @tipo.blank?
      set_tabla('clientes', Cliente.where(estado: @estado).order(:razon_social), true)
    else
      set_tabla('clientes', Cliente.where(estado: 'activo', tipo_cliente: @tipo).order(:razon_social), true)
    end

  end

  # GET /clientes/1 or /clientes/1.json
  def show

    set_tab( :menu, [['Agenda', operacion?], ['Documentos y enlaces', operacion?], 'Causas', 'Asesorias', ['Facturas', finanzas?], ['Tarifas', operacion?]] )

#    @coleccion = {}
    if @options[:menu] == 'Agenda'

      @hoy = Time.zone.today
      set_tabla('age_actividades', @objeto.actividades.order(fecha: :desc), false)
      @age_usuarios = AgeUsuario.where(owner_class: '', owner_id: nil)

    elsif @options[:menu] == 'Documentos y enlaces'
      set_tabla('app_documentos', @objeto.documentos.order(:app_documento), false)
      set_tabla('app_archivos', @objeto.archivos.order(:app_archivo), false)
      set_tabla('app_enlaces', @objeto.enlaces.order(:descripcion), false)

      @d_pendientes = @objeto.documentos_pendientes
      @a_pendientes = @objeto.archivos_pendientes
    elsif @options[:menu] == 'Causas'

      @estados = StModelo.find_by(st_modelo: 'Causa').st_estados.order(:orden).map {|e_ase| e_ase.st_estado}
      @tipos = nil
      @tipo = nil
      @estado = params[:e].blank? ? @estados[0] : params[:e]
      @path = "clientes/#{@objeto.id}?html_options[menu]=Causas"

  #    if @tipo.blank?
        coleccion = @objeto.causas.where(estado: @estado).order(created_at: :desc)
        set_tabla('causas', coleccion, true)
  #    else
  #      tipo = TipoAsesoria.find_by(tipo_asesoria: @tipo)
  #      asesorias = tipo.asesorias.where(estado: ['terminada', 'cerrada'])
  #      set_tabla('asesorias', asesorias, true)
  #    end

    elsif @options[:menu] == 'Asesorias'

      @estados = StModelo.find_by(st_modelo: 'Asesoria').st_estados.order(:orden).map {|e_ase| e_ase.st_estado}
      @tipos = TipoAsesoria.all.order(:tipo_asesoria).map {|ta| ta.tipo_asesoria}
      @tipo = params[:t].blank? ? nil : params[:t]
      @estado = params[:e].blank? ? @estados[0] : params[:e]
      @path = "/clientes/#{@objeto.id}?html_options[menu]=Asesorias"

      if @tipo.blank?
        asesorias = @objeto.asesorias.where(estado: @estado).order(created_at: :desc)
        set_tabla('asesorias', asesorias, true)
      else
        tipo = TipoAsesoria.find_by(tipo_asesoria: @tipo)
        asesorias = @objeto.asesorias.where(tipo_asesoria_id: tipo.id ,estado: ['terminada', 'cerrada'])
        set_tabla('asesorias', asesorias, true)
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
      set_tabla('app_documentos', @objeto.documentos.order(:app_documento), false)
      set_tabla('app_archivos', @objeto.archivos.order(:app_archivo), false)
      set_tabla('app_enlaces', @objeto.enlaces.order(:descripcion), false)

      @d_pendientes = @objeto.documentos_pendientes
      @a_pendientes = @objeto.archivos_pendientes
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
