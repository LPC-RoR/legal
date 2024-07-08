class AsesoriasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_asesoria, only: %i[ show edit update destroy set_tar_servicio generar_cobro facturar liberar_factura swtch_pendiente swtch_urgencia ]
  after_action :asigna_tarifa_defecto, only: %i[ create ]

  # GET /asesorias or /asesorias.json
  def index
    @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

    @estados = StModelo.find_by(st_modelo: 'Asesoria').st_estados.order(:orden).map {|e_ase| e_ase.st_estado}
    @tipos = ['Multas', 'Redacciones']
    @tipo = params[:t].blank? ? nil : params[:t]
    @estado = params[:e].blank? ? (@tipo.blank? ? @estados[0] : nil) : params[:e]
    @path = "/asesorias?"

    unless @tipo.blank?
      corregido = @tipo.singularize == 'Redaccion' ? 'Redacción' : @tipo.singularize
      tipo = TipoAsesoria.find_by(tipo_asesoria: corregido)
      tipo = 'Redacción' if (tipo == 'Redaccion')
      coleccion = Asesoria.where(tipo_asesoria_id: tipo.id).order(urgente: :desc, pendiente: :desc, created_at: :desc)
    end
    unless @estado.blank?
      coleccion = Asesoria.where(estado: @estado).order(urgente: :desc, pendiente: :desc, created_at: :desc)
    end
    set_tabla('asesorias', coleccion, true)

  end

  # GET /asesorias/1 or /asesorias/1.json
  def show
    set_tabla('app_documentos', @objeto.documentos.order(:app_documento), false)
    set_tabla('app_archivos', @objeto.archivos.order(:app_archivo), false)
    set_tabla('app_enlaces', @objeto.enlaces.order(:descripcion), false)
    set_tabla('audiencia-age_actividades', @objeto.actividades.where(tipo: 'Audiencia').order(fecha: :desc), false)
    set_tabla('reunion-age_actividades', @objeto.actividades.where(tipo: 'Reunión').order(fecha: :desc), false)
    set_tabla('tarea-age_actividades', @objeto.actividades.where(tipo: 'Tarea').order(fecha: :desc), false)
  end

  # GET /asesorias/new
  def new
    modelo_asesoria = StModelo.find_by(st_modelo: 'Asesoria')
    @objeto = Asesoria.new(estado: modelo_asesoria.primer_estado.st_estado, urgente: false, pendiente: false)
  end

  # GET /asesorias/1/edit
  def edit
  end

  # POST /asesorias or /asesorias.json
  def create
    @objeto = Asesoria.new(asesoria_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Asesoria fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /asesorias/1 or /asesorias/1.json
  def update
    respond_to do |format|
      if @objeto.update(asesoria_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Asesoria fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def facturar
    unless @objeto.facturacion.blank?
      factura = TarFactura.create(owner_class: 'Cliente', owner_id: @objeto.cliente.id, estado: 'ingreso')
      factura.tar_facturaciones << @objeto.facturacion unless factura.blank?
      if factura.blank?
        redirect_to asesorias_path, notice: 'No se pudo crear la factura'
      else
        @objeto.estado = 'terminada'
        @objeto.save
        redirect_to factura, notice: 'Factura ha sido exitósamente creada'
      end
    else
      redirect_to asesorias_path, notice: 'Asesoría sin cobro asociado'
    end
  end

  def set_tar_servicio
    unless params[:tar_servicio][:tar_servicio_id].blank?
      @objeto.tar_servicio_id = params[:tar_servicio][:tar_servicio_id]
      @objeto.save
    end
    
    redirect_to asesorias_path
  end

  # DELETE /asesorias/1 or /asesorias/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Asesoria fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  def liberar_factura
    facturacion = @objeto.facturacion
    facturacion.tar_factura_id = nil
    facturacion.save

    @objeto.estado = 'tramitación'
    @objeto.save

    redirect_to asesorias_path
  end

  private

    def asigna_tarifa_defecto
      tipo_asesoria = @objeto.tipo_asesoria
      servicios = tipo_asesoria.blank? ? [] : @objeto.cliente.servicios.where(tipo_asesoria_id: tipo_asesoria.id)
      servicio = servicios.empty? ? nil : servicios.first

      unless servicio.blank?
        @objeto.tar_servicio_id = servicio.id
        @objeto.save
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_asesoria
      @objeto = Asesoria.find(params[:id])
    end

    def set_redireccion
      @redireccion = asesorias_path
    end

    # Only allow a list of trusted parameters through.
    def asesoria_params
      params.require(:asesoria).permit(:cliente_id, :tar_servicio_id, :descripcion, :detalle, :fecha, :plazo, :estado, :fecha_uf, :moneda, :monto, :tipo_asesoria_id, :urgente, :pendiente)
    end
end
