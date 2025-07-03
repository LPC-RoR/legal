class Tarifas::TarDetalleCuantiasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tar_detalle_cuantia, only: %i[ show edit update destroy agrega_control_documento elimina_control_documento ]

  # GET /tar_detalle_cuantias or /tar_detalle_cuantias.json
  def index
  end

  # GET /tar_detalle_cuantias/1 or /tar_detalle_cuantias/1.json
  def show
  end

  # GET /tar_detalle_cuantias/new
  def new
    @objeto = TarDetalleCuantia.new
  end

  # GET /tar_detalle_cuantias/1/edit
  def edit
  end

  # POST /tar_detalle_cuantias or /tar_detalle_cuantias.json
  def create
    @objeto = TarDetalleCuantia.new(tar_detalle_cuantia_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Detalle de Cuantía fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_detalle_cuantias/1 or /tar_detalle_cuantias/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_detalle_cuantia_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Detalle de Cuantía fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def agrega_control_documento
    control_documento = ControlDocumento.find(params[:cid])
    unless control_documento.blank?
      @objeto.control_documentos << control_documento
    end
    
    set_redireccion
    redirect_to @redireccion, notice: "Control documental agregado exitosamente al detalle de cuantía"
  end

  def elimina_control_documento
    control_documento = ControlDocumento.find(params[:cid])
    unless control_documento.blank?
      @objeto.control_documentos.delete(control_documento)
    end
    
    set_redireccion
    redirect_to @redireccion, notice: "Control documental eliminado exitosamente al detalle de cuantía"
  end

  # DELETE /tar_detalle_cuantias/1 or /tar_detalle_cuantias/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Detalle de Cuantía fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_detalle_cuantia
      @objeto = TarDetalleCuantia.find(params[:id])
    end

    def set_redireccion
      @redireccion = tabla_path(@objeto)
    end

    # Only allow a list of trusted parameters through.
    def tar_detalle_cuantia_params
      params.require(:tar_detalle_cuantia).permit(:tar_detalle_cuantia, :descripcion, :formula_cuantia, :formula_honorarios, :porcentaje_base)
    end
end
