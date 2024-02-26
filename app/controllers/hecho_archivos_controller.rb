class HechoArchivosController < ApplicationController
  before_action :set_hecho_archivo, only: %i[ show edit update destroy eliminar set_establece ]

  # GET /hecho_archivos or /hecho_archivos.json
  def index
    @coleccion = HechoArchivo.all
  end

  # GET /hecho_archivos/1 or /hecho_archivos/1.json
  def show
  end

  # GET /hecho_archivos/new
  def new
    @objeto = HechoArchivo.new
  end

  # GET /hecho_archivos/1/edit
  def edit
  end

  # POST /hecho_archivos or /hecho_archivos.json
  def create
    @objeto = HechoArchivo.new(hecho_archivo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Hecho archivo was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hecho_archivos/1 or /hecho_archivos/1.json
  def update
    respond_to do |format|
      if @objeto.update(hecho_archivo_params)
        format.html { redirect_to @objeto, notice: "Hecho archivo was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_establece
    @objeto.establece = params[:establece] == 'nil' ? nil : params[:establece]
    age_usuario = perfil_activo.age_usuarios.first
    @objeto.aprobado_por = age_usuario.blank? ? perfil_activo.nombre_perfil : age_usuario.age_usuario
    @objeto.save
    
    redirect_to "/causas/#{@objeto.hecho.causa.id}?html_options[menu]=Hechos"
  end

  # DELETE /hecho_archivos/1 or /hecho_archivos/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to hecho_archivos_url, notice: "Hecho archivo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def eliminar
    hecho = @objeto.hecho
    app_archivo = @objeto.app_archivo
    hecho.app_archivos.delete(app_archivo)
    # En este lugar se debiera mirar la relación con los hechos
    @objeto.delete
#    app_archivo.delete

    redirect_to "/causas/#{@objeto.hecho.tema.causa.id}?html_options[menu]=Hechos"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hecho_archivo
      @objeto = HechoArchivo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hecho_archivo_params
      params.require(:hecho_archivo).permit(:hecho_id, :app_archivo_id, :establece, :orden)
    end
end
