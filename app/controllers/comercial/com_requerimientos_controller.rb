class Comercial::ComRequerimientosController < ApplicationController
  before_action :set_com_requerimiento, only: %i[ show edit update destroy ]

  # anti-bot para create
  MIN_FILL_SECONDS = 3

  after_action :rut_puro, only: %i[ create update ]

  # GET /com_requerimientos or /com_requerimientos.json
  def index
    @coleccion = ComRequerimiento.all
  end

  # GET /com_requerimientos/1 or /com_requerimientos/1.json
  def show
  end

  # GET /com_requerimientos/new
  def new
    @com_requerimiento = ComRequerimiento.new
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

    @com_requerimiento = ComRequerimiento.new(com_requerimiento_params)

    respond_to do |format|
      if @com_requerimiento.save
        format.html { redirect_to root_path, notice: "Requerimiento fue exitosamente creado." }
        format.json { render :show, status: :created, location: @com_requerimiento }
      else
        @objeto = Empresa.new
        error_messages = @com_requerimiento.errors.full_messages
        flash[:errors] = error_messages
        format.html { redirect_to root_path(errors: error_messages), alert: 'Error en la solicitud de contacto comercial' }
        format.json { render json: @com_requerimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /com_requerimientos/1 or /com_requerimientos/1.json
  def update
    respond_to do |format|
      if @com_requerimiento.update(com_requerimiento_params)
        format.html { redirect_to @com_requerimiento, notice: "Requerimiento fue exitosamente actualiado." }
        format.json { render :show, status: :ok, location: @com_requerimiento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @com_requerimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /com_requerimientos/1 or /com_requerimientos/1.json
  def destroy
    @com_requerimiento.destroy!

    respond_to do |format|
      format.html { redirect_to com_requerimientos_path, status: :see_other, notice: "Requerimiento fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    def rut_puro
      return unless @com_requerimiento&.persisted?

      rut = @com_requerimiento.rut.to_s
      normalizado = rut.gsub(/[.\-\s]/, '').upcase
      @com_requerimiento.update_column(:rut, normalizado) if normalizado.present? && normalizado != rut
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_com_requerimiento
      @com_requerimiento = ComRequerimiento.find(params.expect(:id))
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
