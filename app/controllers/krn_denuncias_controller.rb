class KrnDenunciasController < ApplicationController
  before_action :set_krn_denuncia, only: %i[ show edit update destroy ]

  # GET /krn_denuncias or /krn_denuncias.json
  def index
    @krn_denuncias = KrnDenuncia.all
  end

  # GET /krn_denuncias/1 or /krn_denuncias/1.json
  def show
  end

  # GET /krn_denuncias/new
  def new
    @krn_denuncia = KrnDenuncia.new
  end

  # GET /krn_denuncias/1/edit
  def edit
  end

  # POST /krn_denuncias or /krn_denuncias.json
  def create
    @krn_denuncia = KrnDenuncia.new(krn_denuncia_params)

    respond_to do |format|
      if @krn_denuncia.save
        format.html { redirect_to krn_denuncia_url(@krn_denuncia), notice: "Krn denuncia was successfully created." }
        format.json { render :show, status: :created, location: @krn_denuncia }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @krn_denuncia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_denuncias/1 or /krn_denuncias/1.json
  def update
    respond_to do |format|
      if @krn_denuncia.update(krn_denuncia_params)
        format.html { redirect_to krn_denuncia_url(@krn_denuncia), notice: "Krn denuncia was successfully updated." }
        format.json { render :show, status: :ok, location: @krn_denuncia }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @krn_denuncia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_denuncias/1 or /krn_denuncias/1.json
  def destroy
    @krn_denuncia.destroy!

    respond_to do |format|
      format.html { redirect_to krn_denuncias_url, notice: "Krn denuncia was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_denuncia
      @krn_denuncia = KrnDenuncia.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_denuncia_params
      params.require(:krn_denuncia).permit(:cliente_id, :receptor_denuncia_id, :empresa_receptora_id, :motivo_denuncia_id, :investigador_id, :fecha_hora, :fecha_hora_dt, :fecha_hora_recepcion)
    end
end
