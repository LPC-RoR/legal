class Estados::StLogsController < ApplicationController
  before_action :set_st_log, only: %i[ show edit update destroy ]

  # GET /st_logs or /st_logs.json
  def index
    @st_logs = StLog.all
  end

  # GET /st_logs/1 or /st_logs/1.json
  def show
  end

  # GET /st_logs/new
  def new
    @st_log = StLog.new
  end

  # GET /st_logs/1/edit
  def edit
  end

  # POST /st_logs or /st_logs.json
  def create
    @st_log = StLog.new(st_log_params)

    respond_to do |format|
      if @st_log.save
        format.html { redirect_to @st_log, notice: "St log was successfully created." }
        format.json { render :show, status: :created, location: @st_log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @st_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /st_logs/1 or /st_logs/1.json
  def update
    respond_to do |format|
      if @st_log.update(st_log_params)
        format.html { redirect_to @st_log, notice: "St log was successfully updated." }
        format.json { render :show, status: :ok, location: @st_log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @st_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /st_logs/1 or /st_logs/1.json
  def destroy
    @st_log.destroy
    respond_to do |format|
      format.html { redirect_to st_logs_url, notice: "St log was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_st_log
      @st_log = StLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def st_log_params
      params.require(:st_log).permit(:perfil_id, :class_name, :objeto_id, :e_origen, :e_destino)
    end
end
