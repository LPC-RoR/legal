class Karin::KrnDenunciadosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denunciado, only: %i[ show edit update destroy swtch rlzd prsnt set_fld ]

  include MailDesk
  include Karin

  # GET /krn_denunciados or /krn_denunciados.json
  def index
    @coleccion = KrnDenunciado.all
  end

  # GET /krn_denunciados/1 or /krn_denunciados/1.json
  def show
  end

  # GET /krn_denunciados/new
  def new
    @objeto = KrnDenunciado.new(krn_denuncia_id: params[:oid])
  end

  # GET /krn_denunciados/1/edit
  def edit
  end

  # POST /krn_denunciados or /krn_denunciados.json
  def create
    @objeto = KrnDenunciado.new(krn_denunciado_params)

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

        format.html { redirect_to default_redirect_path(@objeto), notice: "Denunciado fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def verify
    @objeto = KrnDenunciado.find_by!(verification_token: params[:token])
    @objeto.update!(email_ok: @objeto.email, verification_token: nil)

    redirect_to default_redirect_path(@objeto), notice: 'Correo verificado correctamente'
  rescue ActiveRecord::RecordNotFound
    redirect_to default_redirect_path(@objeto), alert: 'Token inválido'
  end

  # PATCH/PUT /krn_denunciantes/1 or /krn_denunciantes/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_denunciante_params)
        format.html { redirect_to default_redirect_path(@objeto), notice: "Denunciado fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_denunciados/1 or /krn_denunciados/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_denunciado_params)
        format.html { redirect_to default_redirect_path(@objeto), notice: "Denunciado fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_denunciados/1 or /krn_denunciados/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to default_redirect_path(@objeto), notice: "Denunciado fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_denunciado
      @objeto = KrnDenunciado.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_denunciado_params 
      params.require(:krn_denunciado).permit(:krn_denuncia_id, :krn_empresa_externa_id, :rut, :nombre, :cargo, :lugar_trabajo, :email, :email_ok, :articulo_4_1, :articulo_516, :direccion_notificacion, :empleado_externo, :relacion_denunciante)
    end
end
