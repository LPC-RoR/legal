class ClientesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :set_cliente, only: %i[ show edit update destroy cambio_estado crea_factura aprueba_factura ]

#  include Bandejas

  # GET /clientes or /clientes.json
  def index
      init_tabla('ingreso-clientes', Cliente.where(estado: 'ingreso').order(:razon_social), false)
      add_tabla('activo-clientes', Cliente.where(estado: 'activo').order(:razon_social), false)
      add_tabla('baja-clientes', Cliente.where(estado: 'baja').order(:razon_social), true)
  end

  # GET /clientes/1 or /clientes/1.json
  def show

    init_tab( { menu: ['Causas', 'Asesorias', 'Facturas', 'Tarifas'] }, true )

#    @coleccion = {}
    if @options[:menu] == 'Causas'
      causas_cliente = @objeto.causas
      init_tabla('ingreso-causas', causas_cliente.where(estado: 'ingreso').order(:created_at), false)
      add_tabla('proceso-causas', causas_cliente.where(estado: 'proceso').order(:created_at), false)
      add_tabla('terminada-causas', causas_cliente.where(estado: 'terminada').order(:created_at), true)
    elsif @options[:menu] == 'Asesorias'
      asesorias_cliente = @objeto.asesorias
      init_tabla('ingreso-asesorias', asesorias_cliente.where(estado: 'ingreso').order(:created_at), false)
      add_tabla('proceso-asesorias', asesorias_cliente.where(estado: 'proceso').order(:created_at), false)
      add_tabla('terminada-asesorias', asesorias_cliente.where(estado: 'terminada').order(:created_at), true)
    elsif @options[:menu] == 'Facturas'
      facturas_cliente = @objeto.facturas
      init_tabla('ingreso-tar_facturas', facturas_cliente.where(estado: 'ingreso').order(documento: :desc), false)
      add_tabla('facturada-tar_facturas', facturas_cliente.where(estado: 'facturada').order(documento: :desc), false)
      add_tabla('pagada-tar_facturas', facturas_cliente.where(estado: 'pagada').order(documento: :desc), true)
    elsif @options[:menu] == 'Tarifas'
      init_tabla('tar_tarifas', @objeto.tarifas.order(:created_at), false)
      add_tabla('tar_servicios', @objeto.servicios.order(:created_at), false)
    elsif @options[:menu] == 'Documentos y enlaces'
      @repositorio = AppRepositorio.where(owner_class: 'Cliente').find_by(owner_id: @objeto.id)
      @repositorio = AppRepositorio.create(app_repositorio: @objeto.razon_social, owner_class: 'Cliente', owner_id: @objeto.id) if @repositorio.blank?
      init_tabla('app_directorios', @repositorio.directorios, false)
      add_tabla('app_documentos', @repositorio.documentos, false)
      add_tabla('app_archivos', @repositorio.archivos, false)
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

  # deprecated
  def crea_factura
    concepto = (@objeto.facturacion_pendiente.count == 1 ? @objeto.facturacion_pendiente.first.glosa : "Varios de cliente #{@objeto.razon_social}")
    factura = TarFactura.create(concepto: concepto, owner_class: 'Cliente', owner_id: @objeto.id, estado: 'ingreso',fecha_factura: Time.zone.today.to_date)

    @objeto.facturacion_pendiente.each do |facturacion|
      factura.tar_facturaciones << facturacion
    end

    redirect_to tar_facturas_path
  end

  #deprecated
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
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente
      @objeto = Cliente.find(params[:id])
    end

    def set_redireccion
      @redireccion = clientes_path
    end

    # Only allow a list of trusted parameters through.
    def cliente_params
      params.require(:cliente).permit(:razon_social, :rut, :estado)
    end
end
