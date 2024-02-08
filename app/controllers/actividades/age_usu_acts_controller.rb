class AgeUsuActsController < ApplicationController
  before_action :set_age_usu_act, only: %i[ show edit update destroy ]

  # GET /age_usu_acts or /age_usu_acts.json
  def index
    @age_usu_acts = AgeUsuAct.all
  end

  # GET /age_usu_acts/1 or /age_usu_acts/1.json
  def show
  end

  # GET /age_usu_acts/new
  def new
    @age_usu_act = AgeUsuAct.new
  end

  # GET /age_usu_acts/1/edit
  def edit
  end

  # POST /age_usu_acts or /age_usu_acts.json
  def create
    @age_usu_act = AgeUsuAct.new(age_usu_act_params)

    respond_to do |format|
      if @age_usu_act.save
        format.html { redirect_to @age_usu_act, notice: "Age usu act was successfully created." }
        format.json { render :show, status: :created, location: @age_usu_act }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @age_usu_act.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /age_usu_acts/1 or /age_usu_acts/1.json
  def update
    respond_to do |format|
      if @age_usu_act.update(age_usu_act_params)
        format.html { redirect_to @age_usu_act, notice: "Age usu act was successfully updated." }
        format.json { render :show, status: :ok, location: @age_usu_act }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @age_usu_act.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /age_usu_acts/1 or /age_usu_acts/1.json
  def destroy
    @age_usu_act.destroy
    respond_to do |format|
      format.html { redirect_to age_usu_acts_url, notice: "Age usu act was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_age_usu_act
      @age_usu_act = AgeUsuAct.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def age_usu_act_params
      params.require(:age_usu_act).permit(:age_usuario_id, :age_actividad_id)
    end
end
