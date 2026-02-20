class Comercial::ComRequerimientosController < ApplicationController
  before_action :authenticate_usuario!, except: :create
  before_action :scrty_on, except: :create
  before_action :set_com_requerimiento, only: %i[ show edit update destroy ]
  after_action :rut_puro, only: %i[ create update ]

  skip_before_action :verify_authenticity_token, only: [:verify]

  # anti-bot para create
  MIN_FILL_SECONDS = 3

  # GET /com_requerimientos or /com_requerimientos.json
  def index
    set_pgnt_tbl('com_requerimientos', ComRequerimiento.order(created_at: :desc))
  end

  # GET /com_requerimientos/1 or /com_requerimientos/1.json
  def show
    prfl = get_perfil_activo
    @usuario = prfl.age_usuario unless prfl.blank?
    set_tabla('notas', @objeto.notas, false)
  end

  # GET /com_requerimientos/new
  def new
    @objeto = ComRequerimiento.new
  end

  # GET /com_requerimientos/1/edit
  def edit
  end

  # POST /com_requerimientos or /com_requerimientos.json
  def create
    # ----- early bot rejection -----
    head :ok and return if params.dig(:objeto, :website).present?

    loaded_at = params[:form_loaded_at].to_i
    head :ok and return if loaded_at.zero? || (Time.current.to_i - loaded_at) < MIN_FILL_SECONDS
    # --------------------------------

    @objeto = ComRequerimiento.new(com_requerimiento_params)

    @objeto.verification_token    = SecureRandom.urlsafe_base64,
    @objeto.n_vrfccn_lnks         = (@objeto.n_vrfccn_lnks || 0) + 1,
    @objeto.fecha_vrfccn_lnk      = Time.zone.now,
    @objeto.verification_sent_at  = Time.current

    respond_to do |format|
      if @objeto.save

        # NUEVO: Usar mailer de Platform context directamente
        Contexts::Platform::VrfccnContactoMailer
          .contacto_confirmation(@objeto.id)
          .deliver_later

        format.html { redirect_to root_path, notice: "Requerimiento fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        @objeto = Empresa.new
        error_messages = @objeto.errors.full_messages
        flash[:errors] = error_messages
        format.html { redirect_to root_path(errors: error_messages), alert: 'Error en la solicitud de contacto comercial' }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def verify
    @objeto = ComRequerimiento.find_by!(verification_token: params[:token])
    @objeto.update!(email_ok: @objeto.email, verification_token: nil)

    redirect_to root_path, notice: 'Correo verificado correctamente'
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Token inválido'
  end

  # PATCH/PUT /com_requerimientos/1 or /com_requerimientos/1.json
  def update
    respond_to do |format|
      if @objeto.update(com_requerimiento_params)
        format.html { redirect_to @objeto, notice: "Requerimiento fue exitosamente actualiado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /com_requerimientos/1 or /com_requerimientos/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to com_requerimientos_path, status: :see_other, notice: "Requerimiento fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_com_requerimiento
      @objeto = ComRequerimiento.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def com_requerimiento_params
      params.require(:com_requerimiento).permit(
        :ownr_type, :ownr_id, :realizada,
        :rut, :razon_social, :nombre, :email,
        :contacto_comercial, :reunion_telematica, :laborsafe, :auditoria,
        :externalizacion, :consultoria, :capacitacion, :asesoria_legal, :motivo, :mensaje
        )
    end
end
