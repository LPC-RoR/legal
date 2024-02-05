class CalMesSemsController < ApplicationController
  before_action :set_cal_mes_sem, only: %i[ show edit update destroy ]

  # GET /cal_mes_sems or /cal_mes_sems.json
  def index
    @cal_mes_sems = CalMesSem.all
  end

  # GET /cal_mes_sems/1 or /cal_mes_sems/1.json
  def show
  end

  # GET /cal_mes_sems/new
  def new
    @cal_mes_sem = CalMesSem.new
  end

  # GET /cal_mes_sems/1/edit
  def edit
  end

  # POST /cal_mes_sems or /cal_mes_sems.json
  def create
    @cal_mes_sem = CalMesSem.new(cal_mes_sem_params)

    respond_to do |format|
      if @cal_mes_sem.save
        format.html { redirect_to @cal_mes_sem, notice: "Cal mes sem was successfully created." }
        format.json { render :show, status: :created, location: @cal_mes_sem }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cal_mes_sem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cal_mes_sems/1 or /cal_mes_sems/1.json
  def update
    respond_to do |format|
      if @cal_mes_sem.update(cal_mes_sem_params)
        format.html { redirect_to @cal_mes_sem, notice: "Cal mes sem was successfully updated." }
        format.json { render :show, status: :ok, location: @cal_mes_sem }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cal_mes_sem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cal_mes_sems/1 or /cal_mes_sems/1.json
  def destroy
    @cal_mes_sem.destroy
    respond_to do |format|
      format.html { redirect_to cal_mes_sems_url, notice: "Cal mes sem was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cal_mes_sem
      @cal_mes_sem = CalMesSem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cal_mes_sem_params
      params.require(:cal_mes_sem).permit(:cal_mes_id, :cal_semana_id)
    end
end
