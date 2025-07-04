class Karin::KrnInvDenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_inv_denuncia, only: %i[ show edit update destroy swtch ]
  before_action :set_bck_rdrccn, only:  %i[ edit update destroy ]

  # GET /krn_inv_denuncias or /krn_inv_denuncias.json
  def index
    @coleccion = KrnInvDenuncia.all
  end

  # GET /krn_inv_denuncias/1 or /krn_inv_denuncias/1.json
  def show
  end

  # GET /krn_inv_denuncias/new
  def new
    @objeto = KrnInvDenuncia.new(krn_denuncia_id: params[:oid])
    set_bck_rdrccn
  end

  # GET /krn_inv_denuncias/1/edit
  def edit
  end

  # POST /krn_inv_denuncias or /krn_inv_denuncias.json
  def create
    @objeto = KrnInvDenuncia.new(krn_inv_denuncia_params)
    set_bck_rdrccn

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to params[:bck_rdrccn], notice: "Investigador fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_inv_denuncias/1 or /krn_inv_denuncias/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_inv_denuncia_params)
        format.html { redirect_to params[:bck_rdrccn], notice: "Investigador fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_inv_denuncias/1 or /krn_inv_denuncias/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @bck_rdrccn, notice: "Investigador fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_inv_denuncia
      @objeto = KrnInvDenuncia.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_inv_denuncia_params
      params.require(:krn_inv_denuncia).permit(:krn_investigador_id, :krn_denuncia_id)
    end
end
