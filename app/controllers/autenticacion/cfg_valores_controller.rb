class Autenticacion::CfgValoresController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_cfg_valor, only: %i[ show edit update destroy ]

  # GET /cfg_valores or /cfg_valores.json
  def index
    @cfg_valores = CfgValor.all
  end

  # GET /cfg_valores/1 or /cfg_valores/1.json
  def show
  end

  # GET /cfg_valores/new
  def new
    @cfg_valor = CfgValor.new
  end

  # GET /cfg_valores/1/edit
  def edit
  end

  # POST /cfg_valores or /cfg_valores.json
  def create
    @cfg_valor = CfgValor.new(cfg_valor_params)

    respond_to do |format|
      if @cfg_valor.save
        format.html { redirect_to @cfg_valor, notice: "Cfg valor was successfully created." }
        format.json { render :show, status: :created, location: @cfg_valor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cfg_valor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cfg_valores/1 or /cfg_valores/1.json
  def update
    respond_to do |format|
      if @cfg_valor.update(cfg_valor_params)
        format.html { redirect_to @cfg_valor, notice: "Cfg valor was successfully updated." }
        format.json { render :show, status: :ok, location: @cfg_valor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cfg_valor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cfg_valores/1 or /cfg_valores/1.json
  def destroy
    @cfg_valor.destroy
    respond_to do |format|
      format.html { redirect_to cfg_valores_url, notice: "Cfg valor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cfg_valor
      @cfg_valor = CfgValor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cfg_valor_params
      params.require(:cfg_valor).permit(:cfg_valor, :tipo, :numero, :palabra, :texto, :fecha, :fecha_hora, :check_box, :app_version_id)
    end
end
