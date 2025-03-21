class Repositorios::AppDocumentosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_app_documento, only: %i[ show edit update destroy ]

#  include Bandejas

  # GET /app_documentos or /app_documentos.json
  def index
  end

  # GET /app_documentos/1 or /app_documentos/1.json
  def show
    set_tabla('app_archivos', @objeto.archivos.order(created_at: :desc), false)
    set_tabla('app_escaneos', @objeto.escaneos.order(created_at: :desc), false)
  end

  # GET /app_documentos/new
  def new
    @objeto = AppDocumento.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  # GET /app_documentos/1/edit
  def edit
  end

  # POST /app_documentos or /app_documentos.json
  def create
    @objeto = AppDocumento.new(app_documento_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Documento fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
        format.turbo_stream { render "0p/form/form_update", status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_documentos/1 or /app_documentos/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_documento_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Documento fue exitósamente modificado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_documentos/1 or /app_documentos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Documento fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_documento
      @objeto = AppDocumento.find(params[:id])
    end

    def set_redireccion
      if ['AppDirectorio', 'Causa'].include?(@objeto.ownr_type)
        @redireccion = @objeto.ownr
      elsif ['Cliente'].include?(@objeto.objeto_destino.class.name)
        @redireccion = "/#{@objeto.objeto_destino.class.name.tableize.downcase}/#{@objeto.objeto_destino.id}?html_options[menu]=Documentos"
#      elsif @objeto.causas.any?
#        @redireccion = "/causas/#{@objeto.causas.first.id}?html_options[menu]=Hechos"
      end
    end

    # Only allow a list of trusted parameters through.
    def app_documento_params
      params.require(:app_documento).permit(:app_documento, :publico, :ownr_type, :ownr_id, :existencia, :vencimiento)
    end
end
