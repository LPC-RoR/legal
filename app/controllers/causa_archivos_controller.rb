class CausaArchivosController < ApplicationController
  before_action :set_causa_archivo, only: %i[ show edit update destroy arriba abajo set_seleccionado eliminar ]
  after_action :reordenar, only: :destroy

  # GET /causa_archivos or /causa_archivos.json
  def index
    @coleccion = CausaArchivo.all
  end

  # GET /causa_archivos/1 or /causa_archivos/1.json
  def show
  end

  # GET /causa_archivos/new
  def new
    @objeto = CausaArchivo.new
  end

  # GET /causa_archivos/1/edit
  def edit
  end

  # POST /causa_archivos or /causa_archivos.json
  def create
    @objeto = CausaArchivo.new(causa_archivo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Causa archivo was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /causa_archivos/1 or /causa_archivos/1.json
  def update
    respond_to do |format|
      if @objeto.update(causa_archivo_params)
        format.html { redirect_to @objeto, notice: "Causa archivo was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_seleccionado
    @objeto.seleccionado = (params[:seleccionado] == 'nil') ? nil : ( params[:seleccionado] == 'true' ? true : false )
    @objeto.save

    redirect_to "/causas/#{@objeto.causa.id}?html_options[menu]=Hechos"
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

  # DELETE /causa_archivos/1 or /causa_archivos/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to causa_archivos_url, notice: "Causa archivo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def eliminar
    causa = @objeto.causa
    app_archivo = @objeto.app_archivo
    causa.app_archivos.delete(app_archivo)
    # En este lugar se debiera mirar la relación con los hechos
    @objeto.delete
    app_archivo.delete

    redirect_to "/causas/#{causa.id}?html_options[menu]=Hechos"
  end

  private
    def reordenar
      @objeto.list.each_with_index do |val, index|
        unless val.orden == index + 1
          val.orden = index + 1
          val.save
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_causa_archivo
      @objeto = CausaArchivo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def causa_archivo_params
      params.require(:causa_archivo).permit(:causa_id, :app_archivo_id, :orden, :seleccionado)
    end
end
