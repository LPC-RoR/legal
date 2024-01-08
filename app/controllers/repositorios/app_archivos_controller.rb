class Repositorios::AppArchivosController < ApplicationController
  before_action :set_app_archivo, only: %i[ show edit update destroy ]

  # GET /app_archivos or /app_archivos.json
  def index
  end

  # GET /app_archivos/1 or /app_archivos/1.json
  def show
  end

  # GET /app_archivos/new
  def new
    @objeto = AppArchivo.new(owner_class: params[:class_name], owner_id: params[:objeto_id])
  end

  # GET /app_archivos/1/edit
  def edit
  end

  # POST /app_archivos or /app_archivos.json
  def create
    @objeto = AppArchivo.new(app_archivo_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Archivo fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_archivos/1 or /app_archivos/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_archivo_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Archivo fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_archivos/1 or /app_archivos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Archivo fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_archivo
      @objeto = AppArchivo.find(params[:id])
    end

    def set_redireccion
      if ['AppDirectorio', 'TarFactura'].include?(@objeto.owner.class.name)
        @redireccion = @objeto.owner
      elsif ['AppDocumento'].include?(@objeto.owner.class.name)
        @redireccion = "/#{@objeto.owner.objeto_destino.class.name.tableize.downcase}/#{@objeto.owner.objeto_destino.id}?html_options[menu]=Seguimiento"
      elsif ['Causa', 'Cliente'].include?(@objeto.objeto_destino.class.name)
        @redireccion = "/#{@objeto.objeto_destino.class.name.tableize.downcase}/#{@objeto.objeto_destino.id}?html_options[menu]=Seguimiento"
      else
        @redireccion = app_repositorios_path
      end
    end

    # Only allow a list of trusted parameters through.
    def app_archivo_params
      params.require(:app_archivo).permit(:app_archivo, :archivo, :owner_class, :owner_id)
    end
end
