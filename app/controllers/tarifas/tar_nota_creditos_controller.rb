class Tarifas::TarNotaCreditosController < ApplicationController
  before_action :set_tar_nota_credito, only: %i[ show edit update destroy ]

  # GET /tar_nota_creditos or /tar_nota_creditos.json
  def index
    @tar_nota_creditos = TarNotaCredito.all
  end

  # GET /tar_nota_creditos/1 or /tar_nota_creditos/1.json
  def show
  end

  # GET /tar_nota_creditos/new
  def new
    @tar_nota_credito = TarNotaCredito.new
  end

  # GET /tar_nota_creditos/1/edit
  def edit
  end

  # POST /tar_nota_creditos or /tar_nota_creditos.json
  def create
    @tar_nota_credito = TarNotaCredito.new(tar_nota_credito_params)

    respond_to do |format|
      if @tar_nota_credito.save
        format.html { redirect_to @tar_nota_credito, notice: "Tar nota credito was successfully created." }
        format.json { render :show, status: :created, location: @tar_nota_credito }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tar_nota_credito.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_nota_creditos/1 or /tar_nota_creditos/1.json
  def update
    respond_to do |format|
      if @tar_nota_credito.update(tar_nota_credito_params)
        format.html { redirect_to @tar_nota_credito, notice: "Tar nota credito was successfully updated." }
        format.json { render :show, status: :ok, location: @tar_nota_credito }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tar_nota_credito.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_nota_creditos/1 or /tar_nota_creditos/1.json
  def destroy
    @tar_nota_credito.destroy
    respond_to do |format|
      format.html { redirect_to tar_nota_creditos_url, notice: "Tar nota credito was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_nota_credito
      @tar_nota_credito = TarNotaCredito.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tar_nota_credito_params
      params.require(:tar_nota_credito).permit(:numero, :fecha, :monto, :monto_total, :tar_factura_id)
    end
end
