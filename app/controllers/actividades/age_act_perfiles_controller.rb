class Actividades::AgeActPerfilesController < ApplicationController
  before_action :set_age_act_perfil, only: %i[ show edit update destroy ]

  # GET /age_act_perfiles or /age_act_perfiles.json
  def index
    @age_act_perfiles = AgeActPerfil.all
  end

  # GET /age_act_perfiles/1 or /age_act_perfiles/1.json
  def show
  end

  # GET /age_act_perfiles/new
  def new
    @age_act_perfil = AgeActPerfil.new
  end

  # GET /age_act_perfiles/1/edit
  def edit
  end

  # POST /age_act_perfiles or /age_act_perfiles.json
  def create
    @age_act_perfil = AgeActPerfil.new(age_act_perfil_params)

    respond_to do |format|
      if @age_act_perfil.save
        format.html { redirect_to @age_act_perfil, notice: "Age act perfil was successfully created." }
        format.json { render :show, status: :created, location: @age_act_perfil }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @age_act_perfil.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /age_act_perfiles/1 or /age_act_perfiles/1.json
  def update
    respond_to do |format|
      if @age_act_perfil.update(age_act_perfil_params)
        format.html { redirect_to @age_act_perfil, notice: "Age act perfil was successfully updated." }
        format.json { render :show, status: :ok, location: @age_act_perfil }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @age_act_perfil.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /age_act_perfiles/1 or /age_act_perfiles/1.json
  def destroy
    @age_act_perfil.destroy
    respond_to do |format|
      format.html { redirect_to age_act_perfiles_url, notice: "Age act perfil was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_age_act_perfil
      @age_act_perfil = AgeActPerfil.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def age_act_perfil_params
      params.require(:age_act_perfil).permit(:app_perfil_id, :age_actividad_id)
    end
end
