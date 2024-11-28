class Karin::KrnInvDenunciasController < ApplicationController
  before_action :set_krn_inv_denuncia, only: %i[ show edit update destroy ]

  # GET /krn_inv_denuncias or /krn_inv_denuncias.json
  def index
    @krn_inv_denuncias = KrnInvDenuncia.all
  end

  # GET /krn_inv_denuncias/1 or /krn_inv_denuncias/1.json
  def show
  end

  # GET /krn_inv_denuncias/new
  def new
    @krn_inv_denuncia = KrnInvDenuncia.new
  end

  # GET /krn_inv_denuncias/1/edit
  def edit
  end

  # POST /krn_inv_denuncias or /krn_inv_denuncias.json
  def create
    @krn_inv_denuncia = KrnInvDenuncia.new(krn_inv_denuncia_params)

    respond_to do |format|
      if @krn_inv_denuncia.save
        format.html { redirect_to krn_inv_denuncia_url(@krn_inv_denuncia), notice: "Krn inv denuncia was successfully created." }
        format.json { render :show, status: :created, location: @krn_inv_denuncia }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @krn_inv_denuncia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_inv_denuncias/1 or /krn_inv_denuncias/1.json
  def update
    respond_to do |format|
      if @krn_inv_denuncia.update(krn_inv_denuncia_params)
        format.html { redirect_to krn_inv_denuncia_url(@krn_inv_denuncia), notice: "Krn inv denuncia was successfully updated." }
        format.json { render :show, status: :ok, location: @krn_inv_denuncia }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @krn_inv_denuncia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_inv_denuncias/1 or /krn_inv_denuncias/1.json
  def destroy
    @krn_inv_denuncia.destroy!

    respond_to do |format|
      format.html { redirect_to krn_inv_denuncias_url, notice: "Krn inv denuncia was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_inv_denuncia
      @krn_inv_denuncia = KrnInvDenuncia.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_inv_denuncia_params
      params.require(:krn_inv_denuncia).permit(:krn_investigador_id, :krn_denuncia_id)
    end
end
