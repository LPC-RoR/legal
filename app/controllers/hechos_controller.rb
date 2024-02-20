class HechosController < ApplicationController
  before_action :set_hecho, only: %i[ show edit update destroy nuevo_archivo sel_archivo remueve_documento arriba abajo ]
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

  # via: :post, on: :member Se usa desde un collapse en despliegue de Hechos
  def nuevo_archivo
    unless params[:nuevo_archivo][:nombre].blank?
      archivo = AppArchivo.create(app_archivo: params[:nuevo_archivo][:nombre])
      causa = @objeto.tema.causa

      causa.causa_archivos.create(orden: causa.causa_archivos.count + 1, app_archivo_id: archivo.id)
      @objeto.app_archivos << archivo
    end

    redirect_to "/causas/#{causa.id}?html_options[menu]=Hechos"
  end

  def sel_archivo
    unless params[:aid].blank?
      archivo = AppArchivo.find(params[:aid])
      causa = @objeto.tema.causa
      @objeto.app_archivos << archivo unless @objeto.app_archivos.ids.include?(archivo.id)
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
