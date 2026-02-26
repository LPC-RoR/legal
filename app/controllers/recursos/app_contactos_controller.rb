class Recursos::AppContactosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_app_contacto, only: %i[ show edit update destroy rlzd ]

  include MailDesk

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

    # -----------------------------------------------------------
    # MailDesk: llena los campos del modelo que registra el envío
    set_vrfccn_fields

    respond_to do |format|
      if @objeto.save

        # ------------------------------------
        # MailDesk
        enviar_correo_verificacion('cntct')

        format.html { redirect_to default_redirect_path(@objeto), notice: "Contacto fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def verify
    @objeto = AppContacto.find_by!(verification_token: params[:token])
    @objeto.update!(email_ok: @objeto.email, verification_token: nil)

    redirect_to default_redirect_path(@objeto), notice: 'Correo verificado correctamente'
  rescue ActiveRecord::RecordNotFound
    redirect_to default_redirect_path(@objeto), alert: 'Token inválido'
  end

  # PATCH/PUT /app_contactos/1 or /app_contactos/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_contacto_params)
        format.html { redirect_to default_redirect_path(@objeto), notice: "Contacto fue exitosamente actualizado." }
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
      format.html { redirect_to default_redirect_path(@objeto), notice: "Contacto fue exitosamente eliminado." }
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
