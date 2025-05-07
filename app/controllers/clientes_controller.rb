class ClientesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_cliente, only: %i[ show edit update destroy cambio_estado crea_factura aprueba_factura swtch_urgencia swtch_pendiente swtch_prprty ]
  after_action :rut_puro, only: %i[ create update ]

#  include Bandejas

  # GET /clientes or /clientes.json
  def index
    # Usuarios que no tienen ownr
    @age_usuarios = AgeUsuario.no_ownr

    scp = params[:scp].blank? ? 'emprss' : params[:scp]

    case scp
    when 'emprss'
      cllcn = Cliente.typ('Empresa').cl_ordr
    when 'sndcts'
      cllcn = Cliente.typ('Sindicato').cl_ordr
    when 'trbjdrs'
      cllcn = Cliente.typ('Trabajador').cl_ordr
    when 'actvs'
      cllcn = Cliente.std('activo').cl_ordr
    when 'de_bj'
      cllcn = Cliente.std('baja').cl_ordr
    end

    @scp = scp_item[:clientes][scp.to_sym]

    @vrbls = Variable.all.order(:variable)

    set_tabla('clientes', cllcn, true)

  end

  # GET /clientes/1 or /clientes/1.json
  def show

    set_st_estado(@objeto)
    set_tab( :menu, [['General', operacion?], 'Causas', ['Asesorias', admin?], ['Facturas', finanzas?], ['Tarifas', (admin? or (operacion? and @objeto.tipo_cliente == 'Trabajador'))], ['Productos', dog?]] )

    @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)
    @actividades = @objeto.age_actividades.map {|act| act.age_actividad}

    if @options[:menu] == 'General'

      set_tabla('age_actividades', @objeto.age_actividades.fecha_ordr, false)
      set_tabla('app_archivos', @objeto.as, false)

    elsif @options[:menu] == 'Causas'

      scp = params[:scp].blank? ? 'trmtcn' : params[:scp]

      case scp
      when 'trmtcn'
        cllcn = @objeto.causas.std('tramitación')
      when 'sn_fctrcn'
        cllcn = @objeto.causas.no_fctrds
      when 'trmnds'
        cllcn = @objeto.causas.std('terminada')
      when 'crrds'
        cllcn = @objeto.causas.std('cerrada')
      when 'en_rvsn'
        cllcn = @objeto.causas.std('revisión')
      end

      @scp = scp_item[:causas][scp.to_sym]

      set_tabla('causas', cllcn, true)

    elsif @options[:menu] == 'Asesorias'

      scp = params[:scp].blank? ? 'trmtcn' : params[:scp]

      case scp
      when 'trmtcn'
        cllcn = @objeto.asesorias.std('tramitación')
      when 'trmnds'
        cllcn = @objeto.asesorias.std('terminada')
      when 'crrds'
        cllcn = @objeto.asesorias.std('cerradas')
      when 'mlts'
        cllcn = @objeto.asesorias.typ('Multa')
      when 'crts_dspd'
        cllcn = @objeto.asesorias.typ('CartaDespido')
      when 'rdccns'
        cllcn = @objeto.asesorias.typ('Redacción')
      when 'cnslts'
        cllcn = @objeto.asesorias.typ('Consulta')
      end

      @scp = scp_item[:asesorias][scp.to_sym]

      set_tabla('asesorias', cllcn, true)

    elsif @options[:menu] == 'Facturas'

      scp = params[:scp].blank? ? 'ingrss' : params[:scp]

      case scp
      when 'ingrss'
        cllcn = @objeto.facturas.std('ingreso')
      when 'fctrds'
        cllcn = @objeto.facturas.std('facturada')
      when 'pgds'
        cllcn = @objeto.facturas.std('pagada')
      end

      @scp = scp_item[:tar_facturas][scp.to_sym]

      set_tabla('tar_facturas', cllcn, true)

    elsif @options[:menu] == 'Tarifas'
      
      @estados = []
      @tipos = ['causas', 'asesorias']
      @tipo = params[:t].blank? ? @tipos[0] : params[:t]
      @estado = params[:e].blank? ? @estados[0] : params[:e]
      @path = "/clientes/#{@objeto.id}?html_options[menu]=Tarifas&"

      set_tabla('tar_tarifas', @objeto.tar_tarifas.order(:created_at), false)
      set_tabla('tar_servicios', @objeto.tar_servicios.order(:created_at), false)

    elsif @options[:menu] == 'Productos'
      set_tabla('pro_dtll_ventas', @objeto.pro_dtll_ventas.fecha_ordr, false)
    end
  end

  # GET /clientes/new
  def new
    modelo_cliente = StModelo.find_by(st_modelo: 'Cliente')
    @objeto = Cliente.new(estado: modelo_cliente.primer_estado.st_estado, preferente: false)
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
      params.require(:cliente).permit(:razon_social, :rut, :estado, :tipo_cliente, :preferente, :principal_usuaria, :backup_emails )
    end
end
