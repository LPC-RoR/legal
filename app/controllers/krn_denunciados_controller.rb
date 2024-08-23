class KrnDenunciadosController < ApplicationController
  before_action :set_krn_denunciado, only: %i[ show edit update destroy ]

  # GET /krn_denunciados or /krn_denunciados.json
  def index
    @krn_denunciados = KrnDenunciado.all
  end

  # GET /krn_denunciados/1 or /krn_denunciados/1.json
  def show
  end

  # GET /krn_denunciados/new
  def new
    @krn_denunciado = KrnDenunciado.new
  end

  # GET /krn_denunciados/1/edit
  def edit
  end

  # POST /krn_denunciados or /krn_denunciados.json
  def create
    @krn_denunciado = KrnDenunciado.new(krn_denunciado_params)

    respond_to do |format|
      if @krn_denunciado.save
        format.html { redirect_to krn_denunciado_url(@krn_denunciado), notice: "Krn denunciado was successfully created." }
        format.json { render :show, status: :created, location: @krn_denunciado }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @krn_denunciado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_denunciados/1 or /krn_denunciados/1.json
  def update
    respond_to do |format|
      if @krn_denunciado.update(krn_denunciado_params)
        format.html { redirect_to krn_denunciado_url(@krn_denunciado), notice: "Krn denunciado was successfully updated." }
        format.json { render :show, status: :ok, location: @krn_denunciado }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @krn_denunciado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_denunciados/1 or /krn_denunciados/1.json
  def destroy
    @krn_denunciado.destroy!

    respond_to do |format|
      format.html { redirect_to krn_denunciados_url, notice: "Krn denunciado was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_denunciado
      @krn_denunciado = KrnDenunciado.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_denunciado_params
      params.require(:krn_denunciado).permit(:denuncia_id, :empresa_externa_id, :rut, :nombre, :cargo, :lugar_trabajo, :email, :email_ok, :articulo_4_1)
    end
end
