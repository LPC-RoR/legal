class Karin::KrnTipoMedidasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_tipo_medida, only: %i[ show edit update destroy ]

  # GET /krn_tipo_medidas or /krn_tipo_medidas.json
  def index
    @coleccion = KrnTipoMedida.all
  end

  # GET /krn_tipo_medidas/1 or /krn_tipo_medidas/1.json
  def show
  end

  # GET /krn_tipo_medidas/new
  def new
    @objeto = KrnTipoMedida.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  # GET /krn_tipo_medidas/1/edit
  def edit
  end

  # POST /krn_tipo_medidas or /krn_tipo_medidas.json
  def create
    @objeto = KrnTipoMedida.new(krn_tipo_medida_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tipo de medida fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_tipo_medidas/1 or /krn_tipo_medidas/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_tipo_medida_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tipo de medida fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_tipo_medidas/1 or /krn_tipo_medidas/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Tipo de medida fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_tipo_medida
      @objeto = KrnTipoMedida.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = "/cuentas/#{@objeto.ownr.id}/#{@objeto.ownr.class.name.tableize[0]}tp_mdds"
    end

    # Only allow a list of trusted parameters through.
    def krn_tipo_medida_params
      params.require(:krn_tipo_medida).permit(:ownr_type, :ownr_id, :krn_tipo_medida, :denunciante, :denunciado, :tipo)
    end
end
