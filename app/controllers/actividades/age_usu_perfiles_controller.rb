class AgeUsuPerfilesController < ApplicationController
  before_action :set_age_usu_perfil, only: %i[ show edit update destroy ]

  # GET /age_usu_perfiles or /age_usu_perfiles.json
  def index
    @age_usu_perfiles = AgeUsuPerfil.all
  end

  # GET /age_usu_perfiles/1 or /age_usu_perfiles/1.json
  def show
  end

  # GET /age_usu_perfiles/new
  def new
    @age_usu_perfil = AgeUsuPerfil.new
  end

  # GET /age_usu_perfiles/1/edit
  def edit
  end

  # POST /age_usu_perfiles or /age_usu_perfiles.json
  def create
    @age_usu_perfil = AgeUsuPerfil.new(age_usu_perfil_params)

    respond_to do |format|
      if @age_usu_perfil.save
        format.html { redirect_to @age_usu_perfil, notice: "Age usu perfil was successfully created." }
        format.json { render :show, status: :created, location: @age_usu_perfil }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @age_usu_perfil.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /age_usu_perfiles/1 or /age_usu_perfiles/1.json
  def update
    respond_to do |format|
      if @age_usu_perfil.update(age_usu_perfil_params)
        format.html { redirect_to @age_usu_perfil, notice: "Age usu perfil was successfully updated." }
        format.json { render :show, status: :ok, location: @age_usu_perfil }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @age_usu_perfil.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /age_usu_perfiles/1 or /age_usu_perfiles/1.json
  def destroy
    @age_usu_perfil.destroy
    respond_to do |format|
      format.html { redirect_to age_usu_perfiles_url, notice: "Age usu perfil was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_age_usu_perfil
      @age_usu_perfil = AgeUsuPerfil.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def age_usu_perfil_params
      params.require(:age_usu_perfil).permit(:age_usuario_id, :app_perfil_id)
    end
end
