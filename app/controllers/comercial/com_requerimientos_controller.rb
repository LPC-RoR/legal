class Comercial::ComRequerimientosController < ApplicationController
  before_action :authenticate_usuario!, except: :create
  before_action :scrty_on, except: :create
  before_action :set_com_requerimiento, only: %i[ show edit update destroy ]
  after_action :rut_puro, only: %i[ create update ]

  # anti-bot para create
  MIN_FILL_SECONDS = 3

  after_action :rut_puro, only: %i[ create update ]

  # GET /com_requerimientos or /com_requerimientos.json
  def index
    set_tabla('com_requerimientos', ComRequerimiento.order(created_at: :desc), true)
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

    # --- CORTES TEMPRANOS ANTI-BOT ---
    # Honeypot llenado => bot
    if params.dig(:objeto, :website).present?
      head :ok and return
    end

    # Envío demasiado rápido (desde carga del form)
    loaded_at = params[:form_loaded_at].to_i
    if loaded_at.zero? || (Time.current.to_i - loaded_at) < MIN_FILL_SECONDS
      head :ok and return
    end
    # --- FIN ANTI-BOT ---

    @objeto = ComRequerimiento.new(com_requerimiento_params)

    respond_to do |format|
      if @objeto.save
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
        :externalizacion, :consultoria, :capacitacion, :asesoria_legal,
        :website # el honeypot igual se permite, no se usará
        )
    end
end
