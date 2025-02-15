class ClientesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_cliente, only: %i[ show edit update destroy cambio_estado crea_factura aprueba_factura add_rcrd swtch_urgencia swtch_pendiente swtch_prprty ]
  after_action :rut_puro, only: %i[ create update ]

#  include Bandejas

  # GET /clientes or /clientes.json
  def index
    @age_usuarios = AgeUsuario.no_ownr
    @modelo = StModelo.get_model('Cliente')

    @estados = @modelo.blank? ? [] : @modelo.stts_arry
    @tipos = Cliente::TIPOS

    @estado = std('clientes', params[:e], params[:t])
    @tipo = typ('clientes', params[:e], params[:t])
    @path = '/clientes?'

    @vrbls = Variable.all.order(:variable)

    
    cllcn = Cliente.std(@estado) if @estado.present?
    cllcn = Cliente.typ(@tipo.singularize) if (@tipo.present? and @estado.blank?)

    set_tabla('clientes', cllcn.order(preferente: :desc, razon_social: :asc), true)

  end

  # GET /clientes/1 or /clientes/1.json
  def show

    set_st_estado(@objeto)

    set_tab( :menu, [['General', operacion?], 'Causas', ['Asesorias', admin?], ['Facturas', finanzas?], ['Tarifas', (admin? or (operacion? and @objeto.tipo_cliente == 'Trabajador'))], ['Productos', dog?]] )

    @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

    if @options[:menu] == 'General'

      @hoy = Time.zone.today
      set_tabla('age_actividades', @objeto.age_actividades.fecha_ordr, false)

      set_tabla('app_documentos', @objeto.ds, false)
      set_tabla('app_archivos', @objeto.as, false)

      @d_pendientes = @objeto.documentos_pendientes
      @a_pendientes = @objeto.archivos_pendientes

    elsif @options[:menu] == 'Causas'

      @estados = StModelo.find_by(st_modelo: 'Causa').st_estados.order(:orden).map {|e_ase| e_ase.st_estado}
      @tipos = ['por_facturar']
      @tipos = nil

      @estado = (params[:e].blank? and params[:t] != 'por_facturar') ? @estados[0] : params[:e]
      @path = "/clientes/#{@objeto.id}?html_options[menu]=Causas&"

      if params[:t] == 'por_facturar'
        @tipo = 'por_facturar'
        cllcn = @objeto.causas.no_fctrds
      else
        cllcn = @objeto.causas.where(estado: @estado).order(created_at: :desc)
      end

      set_tabla('causas', cllcn, true)

    elsif @options[:menu] == 'Asesorias'

      @estados = StModelo.find_by(st_modelo: 'Asesoria').st_estados.order(:orden).map {|e_ase| e_ase.st_estado}
      @tipos = ['Multas', 'Redacciones']
      @tipo = params[:t].blank? ? nil : params[:t]
      @estado = params[:e].blank? ? (@tipo.blank? ? @estados[0] : nil) : params[:e]
      @path = "/clientes/#{@objeto.id}?html_options[menu]=Asesorias&"

      unless @tipo.blank?
        corregido = @tipo.singularize == 'Redaccion' ? 'Redacción' : @tipo.singularize
        tipo = TipoAsesoria.find_by(tipo_asesoria: corregido)
        tipo = 'Redacción' if (tipo == 'Redaccion')
        coleccion = @objeto.asesorias.where(tipo_asesoria_id: tipo.id).order(created_at: :desc)
      end
      unless @estado.blank?
        coleccion = @objeto.asesorias.where(estado: @estado).order(created_at: :desc)
      end
      set_tabla('asesorias', coleccion, true)

    elsif @options[:menu] == 'Facturas'
      @estados = StModelo.find_by(st_modelo: 'TarFactura').st_estados.order(:orden).map {|e_ase| e_ase.st_estado}
      @tipos = nil
      @tipo = nil
      @estado = params[:e].blank? ? @estados[0] : params[:e]
      @path = "/clientes/#{@objeto.id}?html_options[menu]=Facturas&"

      coleccion = @objeto.facturas.where(estado: @estado).order(created_at: :desc)
      set_tabla('tar_facturas', coleccion, true)

    elsif @options[:menu] == 'Tarifas'
      @estados = []
      @tipos = ['causas', 'asesorias']
      @tipo = params[:t].blank? ? @tipos[0] : params[:t]
      @estado = params[:e].blank? ? @estados[0] : params[:e]
      @path = "/clientes/#{@objeto.id}?html_options[menu]=Tarifas&"

      set_tabla('tar_tarifas', @objeto.tarifas.order(:created_at), false)
      set_tabla('tar_servicios', @objeto.servicios.order(:created_at), false)
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

  def add_rcrd
    if params[:v_nm].present?
      chld = Variable.find_by(variable: params[:v_nm].split('_').join(' '))
      unless chld.blank?
        @objeto.variables << chld
      end
    end

    redirect_to '/clientes'
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
      params.require(:cliente).permit(:razon_social, :rut, :estado, :tipo_cliente, :preferente )
    end
end
