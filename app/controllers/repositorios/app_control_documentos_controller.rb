class Repositorios::AppAppControlDocumentosController < ApplicationController
  before_action :set_control_documento, only: %i[ show edit update destroy ]

  # GET /control_documentos or /control_documentos.json
  def index
    @coleccion = AppControlDocumento.all
  end

  # GET /control_documentos/1 or /control_documentos/1.json
  def show
  end

  # GET /control_documentos/new
  def new
    @objeto = AppAppControlDocumento.new(ownr_class: params[:class_name], ownr_id: params[:objeto_id])
  end

  # GET /control_documentos/1/edit
  def edit
  end

  # POST /control_documentos or /control_documentos.json
  def create
    @objeto = AppControlDocumento.new(control_documento_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Documento controlado ha sido exitosamente creado." }
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
        format.html { redirect_to @redireccion, notice: "Documento controlado ha sido exitosamente actualizado." }
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
      format.html { redirect_to @redireccion, notice: "Documento controlado ha sido exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_control_documento
      @objeto = AppControlDocumento.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/#{@objeto.owner.class.name.tableize}/@objeto.owner.id?html_options[tab]=Documentos"
    end

    # Only allow a list of trusted parameters through.
    def control_documento_params
      params.require(:control_documento).permit(:app_control_documento, :existencia, :vencimiento, :ownr_class, :ownr_id)
    end
end
