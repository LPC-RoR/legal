class Recursos::AppContactosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_app_contacto, only: %i[ show edit update destroy ]
  before_action :set_bck_rdrccn, only:  %i[ edit update destroy ]

  # GET /app_contactos or /app_contactos.json
  def index
  end

  # GET /app_contactos/1 or /app_contactos/1.json
  def show
  end

  # GET /app_contactos/new
  def new
    @objeto = AppContacto.new(ownr_type: params[:oclss], ownr_id: params[:oid])
    set_bck_rdrccn
  end

  # GET /app_contactos/1/edit
  def edit
  end

  # POST /app_contactos or /app_contactos.json
  def create
    @objeto = AppContacto.new(app_contacto_params)
    set_bck_rdrccn

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to params[:bck_rdrccn], notice: "Contacto fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_contactos/1 or /app_contactos/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_contacto_params)
        format.html { redirect_to params[:bck_rdrccn], notice: "Contacto fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_contactos/1 or /app_contactos/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @bck_rdrccn, notice: "Contacto fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_contacto
      @objeto = AppContacto.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_contacto_params
      params.require(:app_contacto).permit(:ownr_type, :ownr_id, :nombre, :telefono, :email, :grupo)
    end
end
