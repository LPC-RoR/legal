class Karin::KrnEmpresaExternasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_empresa_externa, only: %i[ show edit update destroy ]

  # GET /krn_empresa_externas or /krn_empresa_externas.json
  def index
    @krn_empresa_externas = KrnEmpresaExterna.all
  end

  # GET /krn_empresa_externas/1 or /krn_empresa_externas/1.json
  def show
  end

  # GET /krn_empresa_externas/new
  def new
    @krn_empresa_externa = KrnEmpresaExterna.new
  end

  # GET /krn_empresa_externas/1/edit
  def edit
  end

  # POST /krn_empresa_externas or /krn_empresa_externas.json
  def create
    @krn_empresa_externa = KrnEmpresaExterna.new(krn_empresa_externa_params)

    respond_to do |format|
      if @krn_empresa_externa.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Krn empresa externa was successfully created." }
        format.json { render :show, status: :created, location: @krn_empresa_externa }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @krn_empresa_externa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_empresa_externas/1 or /krn_empresa_externas/1.json
  def update
    respond_to do |format|
      if @krn_empresa_externa.update(krn_empresa_externa_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Krn empresa externa was successfully updated." }
        format.json { render :show, status: :ok, location: @krn_empresa_externa }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @krn_empresa_externa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_empresa_externas/1 or /krn_empresa_externas/1.json
  def destroy
    get_rdrccn
    @krn_empresa_externa.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Krn empresa externa was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_empresa_externa
      @krn_empresa_externa = KrnEmpresaExterna.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = krn_empresa_externas_path
    end

    # Only allow a list of trusted parameters through.
    def krn_empresa_externa_params
      params.require(:krn_empresa_externa).permit(:rut, :razon_social, :tipo, :contacto, :email_contacto)
    end
end
