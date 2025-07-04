class Repositorios::ControlDocumentosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_control_documento, only: %i[ show edit update destroy crea_documento_controlado arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /control_documentos or /control_documentos.json
  def index
    @coleccion = ControlDocumento.all
  end

  # GET /control_documentos/1 or /control_documentos/1.json
  def show
  end

  # GET /control_documentos/new
  def new
    ownr = params[:oclss].constantize.find(params[:oid])
    tipo = params[:oclss] == 'TarDetalleCuantia' ? 'Archivo' : nil
    @objeto = ControlDocumento.new(ownr_type: params[:oclss], ownr_id: params[:oid], tipo: tipo, orden: ownr.control_documentos.count + 1)
  end

  # GET /control_documentos/1/edit
  def edit
  end

  # POST /control_documentos or /control_documentos.json
  def create
    @objeto = ControlDocumento.new(control_documento_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Documento controlado fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # Crea Documentos y Archivos controlados
  def crea_documento_controlado
    owner = params[:oclss].constantize.find(params[:oid])
    unless owner.blank? 
      if @objeto.tipo == 'Documento'
        AppDocumento.create(owner_class: owner.class.name, owner_id: owner.id, app_documento: @objeto.nombre, existencia: @objeto.control, documento_control: true, visible_para: @objeto.visible_para)
      else
        AppArchivo.create(owner_class: owner.class.name, owner_id: owner.id, app_archivo: @objeto.nombre, control: @objeto.control, documento_control: true, visible_para: @objeto.visible_para)
      end  
    end

    if params[:oclss] == 'Causa'
      redirect_to "/causas/#{owner.id}"
    elsif params[:oclss] == 'Cliente'
      redirect_to "/clientes/#{owner.id}?html_options[menu]=Documentos"
    end
  end

  # PATCH/PUT /control_documentos/1 or /control_documentos/1.json
  def update
    respond_to do |format|
      if @objeto.update(control_documento_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Documento controlado fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def arriba
    owner = @objeto.owner
    anterior = @objeto.anterior
    @objeto.orden -= 1
    @objeto.save
    anterior.orden += 1
    anterior.save

    redirect_to @objeto.redireccion
  end

  def abajo
    owner = @objeto.owner
    siguiente = @objeto.siguiente
    @objeto.orden += 1
    @objeto.save
    siguiente.orden -= 1
    siguiente.save

    redirect_to @objeto.redireccion
  end

  # DELETE /control_documentos/1 or /control_documentos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Documento controlado fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_control_documento
      @objeto = ControlDocumento.find(params[:id])
    end

    def set_redireccion
      case @objeto.ownr.class.name
      when 'TarDetalleCuantia'
        @redireccion = "/tablas/cuantias_tribunales"
      when 'TipoCausa'
        @redireccion = "/tablas/tipos"
      when 'StModelo'
        @redireccion = '/st_modelos'
      end
    end

    # Only allow a list of trusted parameters through.
    def control_documento_params
      params.require(:control_documento).permit(:nombre, :descripcion, :tipo, :control, :ownr_type, :ownr_id, :orden, :visible_para, :codigo)
    end
end
