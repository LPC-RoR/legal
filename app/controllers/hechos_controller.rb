class HechosController < ApplicationController
  before_action :set_hecho, only: %i[ show edit update destroy nuevo_documento sel_documento remueve_documento arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /hechos or /hechos.json
  def index
    @coleccion = Hecho.all
  end

  # GET /hechos/1 or /hechos/1.json
  def show
  end

  # GET /hechos/new
  def new
    tema = Tema.find(params[:tid])
    @objeto = Hecho.new(tema_id: params[:tid], orden: tema.hechos.count + 1)
  end

  # GET /hechos/1/edit
  def edit
  end

  # POST /hechos or /hechos.json
  def create
    @objeto = Hecho.new(hecho_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Hecho fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hechos/1 or /hechos/1.json
  def update
    respond_to do |format|
      if @objeto.update(hecho_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Hecho fue exitósamente actualizado." }
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

  def nuevo_documento
    unless params[:add_documento][:nombre].blank?
      documento = AppDocumento.create(app_documento: params[:add_documento][:nombre])
      causa = @objeto.tema.causa
      causa.app_documentos << documento
      @objeto.app_documentos << documento
    end

    redirect_to "/causas/#{causa.id}?html_options[menu]=Hechos"
  end

  def sel_documento
    unless params[:did].blank?
      documento = AppDocumento.find(params[:did])
      causa = @objeto.tema.causa
      @objeto.app_documentos << documento unless @objeto.app_documentos.ids.include?(documento.id)
    end

    redirect_to "/causas/#{causa.id}?html_options[menu]=Hechos"
  end

  def remueve_documento
    unless params[:did].blank?
      documento = AppDocumento.find(params[:did])
      causa = @objeto.tema.causa
      if documento.hechos.count < 2
        causa.app_documentos.delete(documento)
        documento.delete
      end
      @objeto.app_documentos.delete(documento)
    end

    redirect_to "/causas/#{causa.id}?html_options[menu]=Hechos"
  end

  # DELETE /hechos/1 or /hechos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Hecho fue exitósamente eliminad." }
      format.json { head :no_content }
    end
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
    def set_hecho
      @objeto = Hecho.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/causas/#{@objeto.tema.causa.id}?html_options[menu]=Hechos"
    end

    # Only allow a list of trusted parameters through.
    def hecho_params
      params.require(:hecho).permit(:tema_id, :orden, :hecho, :cita, :archivo, :documento, :paginas)
    end
end
