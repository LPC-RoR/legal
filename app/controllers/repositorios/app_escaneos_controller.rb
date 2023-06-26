class Repositorios::AppEscaneosController < ApplicationController
  before_action :set_app_escaneo, only: %i[ show edit update destroy ]

  # GET /app_escaneos or /app_escaneos.json
  def index
    @coleccion = AppEscaneo.all
  end

  # GET /app_escaneos/1 or /app_escaneos/1.json
  def show
    init_tabla('app_imagenes', @objeto.imagenes.order(:orden), false)
  end

  # GET /app_escaneos/new
  def new
  end

  def crea_escaneo
     @objeto = AppEscaneo.create(ownr_class: params[:ownr_class], ownr_id: params[:ownr_id])

     owner = params[:ownr_class].constantize.find(params[:ownr_id])

     redirect_to owner
  end

  # GET /app_escaneos/1/edit
  def edit
  end

  # POST /app_escaneos or /app_escaneos.json
  def create
    @objeto = AppEscaneo.new(app_escaneo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to app_escaneo_url(@objeto), notice: "Escaneo fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
        format.turbo_stream { render "0p/form/form_update", status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_escaneos/1 or /app_escaneos/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_escaneo_params)
        format.html { redirect_to app_escaneo_url(@objeto), notice: "Escaneo fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_escaneos/1 or /app_escaneos/1.json
  def destroy
    @objeto.destroy

    respond_to do |format|
      format.html { redirect_to app_escaneos_url, notice: "Escaneo fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_escaneo
      @objeto = AppEscaneo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_escaneo_params
      params.require(:app_escaneo).permit(:ownr_class, :ownr_id)
    end
end
