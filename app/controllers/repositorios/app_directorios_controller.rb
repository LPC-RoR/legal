class Repositorios::AppDirectoriosController < ApplicationController
  before_action :set_app_directorio, only: %i[ show edit update destroy ]

#  include Bandejas

  # GET /app_directorios or /app_directorios.json
  def index
  end

  # GET /app_directorios/1 or /app_directorios/1.json
  def show
    @padres = AppDirectorio.where(id: @objeto.padres_ids)
    set_tabla('app_directorios', @objeto.directorios, false)
    set_tabla('app_archivos', @objeto.archivos, false)
  end

  # GET /app_directorios/new
  def new
    @objeto = AppDirectorio.new(owner_class: params[:class_name], owner_id: params[:objeto_id])
  end

  def nuevo
    padre = AppDirectorio.find(params[:objeto_id])
    directorio = AppDirectorio.create(app_directorio: params[:nuevo_directorio][:directorio])
    padre.children <<  directorio

    redirect_to padre
  end

  # GET /app_directorios/1/edit
  def edit
  end

  # POST /app_directorios or /app_directorios.json
  def create
    @objeto = AppDirectorio.new(app_directorio_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Directorio fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_directorios/1 or /app_directorios/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_directorio_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Directorio fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_directorios/1 or /app_directorios/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Directorio fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_directorio
      @objeto = AppDirectorio.find(params[:id])
    end

    def set_redireccion
      if @objeto.owner.class.name == 'AppDirectorio'
        @redireccion = @objeto.owner
      elsif ['Causa', 'Cliente'].include?(@objeto.objeto_destino.class.name)
        @redireccion = "/#{@objeto.objeto_destino.class.name.tableize.downcase}/#{@objeto.objeto_destino.id}?html_options[menu]=Documentos+y+enlaces"
      end
    end

    # Only allow a list of trusted parameters through.
    def app_directorio_params
      params.require(:app_directorio).permit(:app_directorio, :owner_class, :owner_id)
    end
end
