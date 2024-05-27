class Actividades::AgeLogsController < ApplicationController
  before_action :set_age_log, only: %i[ show edit update destroy ]

  # GET /age_logs or /age_logs.json
  def index
    @coleccion = AgeLog.all
  end

  # GET /age_logs/1 or /age_logs/1.json
  def show
  end

  # GET /age_logs/new
  def new
    @objeto = AgeLog.new(age_actividad_id: params[:aid])
  end

  # GET /age_logs/1/edit
  def edit
  end

  # POST /age_logs or /age_logs.json
  def create
    @objeto = AgeLog.new(age_log_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Modificación de la actividad fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /age_logs/1 or /age_logs/1.json
  def update
    respond_to do |format|
      if @objeto.update(age_log_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Modificación de la actividad fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /age_logs/1 or /age_logs/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Modificación de la actividad fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_age_log
      @objeto = AgeLog.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/age_actividades"
    end

    # Only allow a list of trusted parameters through.
    def age_log_params
      params.require(:age_log).permit(:fecha, :actividad, :age_actividad_id)
    end
end
