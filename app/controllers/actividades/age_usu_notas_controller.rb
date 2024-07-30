class Actividades::AgeUsuNotasController < ApplicationController
  before_action :set_age_usu_nota, only: %i[ show edit update destroy ]

  # GET /age_usu_notas or /age_usu_notas.json
  def index
    @age_usu_notas = AgeUsuNota.all
  end

  # GET /age_usu_notas/1 or /age_usu_notas/1.json
  def show
  end

  # GET /age_usu_notas/new
  def new
    @age_usu_nota = AgeUsuNota.new
  end

  # GET /age_usu_notas/1/edit
  def edit
  end

  # POST /age_usu_notas or /age_usu_notas.json
  def create
    @age_usu_nota = AgeUsuNota.new(age_usu_nota_params)

    respond_to do |format|
      if @age_usu_nota.save
        format.html { redirect_to age_usu_nota_url(@age_usu_nota), notice: "Age usu nota was successfully created." }
        format.json { render :show, status: :created, location: @age_usu_nota }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @age_usu_nota.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /age_usu_notas/1 or /age_usu_notas/1.json
  def update
    respond_to do |format|
      if @age_usu_nota.update(age_usu_nota_params)
        format.html { redirect_to age_usu_nota_url(@age_usu_nota), notice: "Age usu nota was successfully updated." }
        format.json { render :show, status: :ok, location: @age_usu_nota }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @age_usu_nota.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /age_usu_notas/1 or /age_usu_notas/1.json
  def destroy
    @age_usu_nota.destroy!

    respond_to do |format|
      format.html { redirect_to age_usu_notas_url, notice: "Age usu nota was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_age_usu_nota
      @age_usu_nota = AgeUsuNota.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def age_usu_nota_params
      params.require(:age_usu_nota).permit(:age_usuario_id, :nota_id)
    end
end
