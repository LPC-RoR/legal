class Aplicacion::AppDocumentosController < ApplicationController
  before_action :set_app_documento, only: %i[ show edit update destroy ]

  # GET /app_documentos or /app_documentos.json
  def index
    @coleccion = AppDocumento.all
  end

  # GET /app_documentos/1 or /app_documentos/1.json
  def show
    @coleccion = {}
    @coleccion['app_archivos'] = @objeto.archivos.order(created_at: :desc)
  end

  # GET /app_documentos/new
  def new
    @objeto = AppDocumento.new(owner_class: params[:class_name], owner_id: params[:objeto_id])
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
        format.html { redirect_to @redireccion, notice: "App documento was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_documentos/1 or /app_documentos/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_documento_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "App documento was successfully updated." }
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
      format.html { redirect_to @redireccion, notice: "App documento was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_documento
      @objeto = AppDocumento.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.padre
    end

    # Only allow a list of trusted parameters through.
    def app_documento_params
      params.require(:app_documento).permit(:documento, :publico, :owner_class, :owner_id)
    end
end
