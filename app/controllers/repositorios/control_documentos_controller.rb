class Repositorios::ControlDocumentosController < ApplicationController
  before_action :set_control_documento, only: %i[ show edit update destroy ]

  # GET /control_documentos or /control_documentos.json
  def index
    @coleccion = ControlDocumento.all
  end

  # GET /control_documentos/1 or /control_documentos/1.json
  def show
  end

  # GET /control_documentos/new
  def new
    owner = params[:clss].constantize.find(params[:oid])
    @objeto = ControlDocumento.new(owner_class: params[:clss], owner_id: params[:oid], orden: owner.control_documentos.count + 1)
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
        format.html { redirect_to @redireccion, notice: "Control de documento fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /control_documentos/1 or /control_documentos/1.json
  def update
    respond_to do |format|
      if @objeto.update(control_documento_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Control de documento fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /control_documentos/1 or /control_documentos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Control de documento fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_control_documento
      @objeto = ControlDocumento.find(params[:id])
    end

    def set_redireccion
      case @objeto.owner.class.name
      when 'TipoCausa'
        @redireccion = "/tablas?tb=#{tb_index('tipos_causas_asesorias')}"
      when 'StModelo'
        @redireccion = '/st_modelos'
      end
    end

    # Only allow a list of trusted parameters through.
    def control_documento_params
      params.require(:control_documento).permit(:nombre, :descripcion, :tipo, :control, :owner_class, :owner_id, :orden)
    end
end
