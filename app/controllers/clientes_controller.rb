class ClientesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :set_cliente, only: %i[ show edit update destroy cambio_estado crea_factura aprueba_factura ]

#  include Bandejas

  # GET /clientes or /clientes.json
  def index
  end

  # GET /clientes/1 or /clientes/1.json
  def show

    init_tab( { menu: ['Facturas', 'Causas', 'Consultorías', 'Documentos y enlaces', 'Tarifas y servicios'] }, true )

#    @coleccion = {}
    if @options[:menu] == 'Facturas'
      init_tabla('tar_facturas', @objeto.facturas.order(documento: :desc), false)
    elsif @options[:menu] == 'Causas'
      init_tabla('causas', @objeto.causas.order(:created_at), false)
    elsif @options[:menu] == 'Consultorías'
      init_tabla('consultorias', @objeto.consultorias.order(:created_at), false)
    elsif @options[:menu] == 'Tarifas y servicios'
      init_tabla('tar_tarifas', @objeto.tarifas.order(:created_at), false)
      add_tabla('tar_servicios', @objeto.servicios.order(:created_at), false)
    elsif @options[:menu] == 'Documentos y enlaces'
      @repo = AppRepo.where(owner_class: 'Cliente').find_by(owner_id: @objeto.id)
      @repo = AppRepo.create(repositorio: @objeto.razon_social, owner_class: 'Cliente', owner_id: @objeto.id) if @repo.blank?
      init_tabla('app_directorios', @repo.directorios, false)
      add_tabla('app_documentos', @repo.documentos, false)
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
        format.html { redirect_to @redireccion, notice: "Cliente was successfully created." }
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
        format.html { redirect_to @redireccion, notice: "Cliente was successfully updated." }
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

    redirect_to "/st_bandejas?m=#{@objeto.class.name}&e=#{@objeto.estado}"
  end

  def crea_factura
    concepto = (@objeto.facturacion_pendiente.count == 1 ? @objeto.facturacion_pendiente.first.glosa : "Varios de cliente #{@objeto.razon_social}")
    factura = TarFactura.create(concepto: concepto, owner_class: 'Cliente', owner_id: @objeto.id, estado: 'ingreso',fecha_factura: Time.zone.today.to_date)

    @objeto.facturacion_pendiente.each do |facturacion|
      factura.tar_facturaciones << facturacion
    end

    redirect_to tar_facturas_path
  end

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
      format.html { redirect_to @redireccion, notice: "Cliente was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente
      @objeto = Cliente.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/st_bandejas?m=Cliente&e=ingreso" 
    end

    # Only allow a list of trusted parameters through.
    def cliente_params
      params.require(:cliente).permit(:razon_social, :rut, :estado)
    end
end
