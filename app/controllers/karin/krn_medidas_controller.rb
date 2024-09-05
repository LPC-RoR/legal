class Karin::KrnMedidasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_medida, only: %i[ show edit update destroy ]

  # GET /krn_medidas or /krn_medidas.json
  def index
    @coleccion = KrnMedida.all
  end

  # GET /krn_medidas/1 or /krn_medidas/1.json
  def show
  end

  # GET /krn_medidas/new
  def new
    @objeto = KrnMedida.new(krn_lst_medida_id: params[:oid])
  end

  # GET /krn_medidas/1/edit
  def edit
  end

  # POST /krn_medidas or /krn_medidas.json
  def create
    @objeto = KrnMedida.new(krn_medida_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Medida fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_medidas/1 or /krn_medidas/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_medida_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Medida fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_medidas/1 or /krn_medidas/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Medida fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_medida
      @objeto = KrnMedida.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.krn_lst_medida
    end

    # Only allow a list of trusted parameters through.
    def krn_medida_params
      params.require(:krn_medida).permit(:krn_lst_medida_id, :krn_tipo_medida_id, :krn_medida, :detalle)
    end
end
