class Karin::KrnTestigosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_testigo, only: %i[ show edit update destroy swtch rlzd prsnt set_fld ]

  include MailDesk
  include Karin

  # GET /krn_testigos or /krn_testigos.json
  def index
    @coleccion = KrnTestigo.all
  end

  # GET /krn_testigos/1 or /krn_testigos/1.json
  def show
  end

  # GET /krn_testigos/new
  def new
    @objeto = KrnTestigo.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  # GET /krn_testigos/1/edit
  def edit
  end

  # POST /krn_testigos or /krn_testigos.json
  def create
    @objeto = KrnTestigo.new(krn_testigo_params)

    # -----------------------------------------------------------
    # MailDesk: llena los campos del modelo que registra el envío
    # En este modelo la varificación es manual
    # set_vrfccn_fields

    respond_to do |format|
      if @objeto.save

        # ------------------------------------
        # MailDesk
        # En este modelo la varificación es manual
        # enviar_correo_verificacion('dnncnt')

        format.html { redirect_to default_redirect_path(@objeto), notice: "Testigo fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def verify
    @objeto = KrnTestigo.find_by!(verification_token: params[:token])
    @objeto.update!(email_ok: @objeto.email, verification_token: nil)

    redirect_to default_redirect_path(@objeto), notice: 'Correo verificado correctamente'
  rescue ActiveRecord::RecordNotFound
    redirect_to default_redirect_path(@objeto), alert: 'Token inválido'
  end

  # PATCH/PUT /krn_testigos/1 or /krn_testigos/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_testigo_params)
        format.html { redirect_to default_redirect_path(@objeto), notice: "Testigo fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_testigos/1 or /krn_testigos/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to default_redirect_path(@objeto), notice: "Testigo fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_testigo
      @objeto = KrnTestigo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_testigo_params
      params.require(:krn_testigo).permit(:ownr_type, :ownr_id, :empleado_externo, :krn_empresa_externa_id, :rut, :nombre, :cargo, :lugar_trabajo, :email, :email_ok, :articulo_4_1, :articulo_516, :direccion_notificacion)
    end
end
