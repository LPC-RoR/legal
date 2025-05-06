class Recursos::AppContactosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_app_contacto, only: %i[ show edit update destroy ]

  # GET /app_contactos or /app_contactos.json
  def index
  end

  # GET /app_contactos/1 or /app_contactos/1.json
  def show
  end

  # GET /app_contactos/new
  def new
    @objeto = AppContacto.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  # GET /app_contactos/1/edit
  def edit
  end

  # POST /app_contactos or /app_contactos.json
  def create
    @objeto = AppContacto.new(app_contacto_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @rdrccn, notice: "Contacto fue exitósamente creado." }
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
        set_redireccion
        format.html { redirect_to @rdrccn, notice: "Contacto fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_contactos/1 or /app_contactos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Contacto fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_contacto
      @objeto = AppContacto.find(params[:id])
    end

    def set_redireccion
      if ['Empresa', 'Cliente'].include?(@objeto.ownr_type)
        @rdrccn = "/cuentas/#{@objeto.ownr.class.name.tableize[0]}_#{@objeto.ownr.id}/nmn"
      else
        @rdrccn = @objeto.ownr
      end
    end

    # Only allow a list of trusted parameters through.
    def app_contacto_params
      params.require(:app_contacto).permit(:ownr_type, :ownr_id, :nombre, :telefono, :email, :grupo)
    end
end
