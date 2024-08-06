class Producto::ProNominasController < ApplicationController
  before_action :set_pro_nomina, only: %i[ show edit update destroy ]

  # GET /pro_nominas or /pro_nominas.json
  def index
    @pro_nominas = ProNomina.all
  end

  # GET /pro_nominas/1 or /pro_nominas/1.json
  def show
  end

  # GET /pro_nominas/new
  def new
    @pro_nomina = ProNomina.new
  end

  # GET /pro_nominas/1/edit
  def edit
  end

  # POST /pro_nominas or /pro_nominas.json
  def create
    @pro_nomina = ProNomina.new(pro_nomina_params)

    respond_to do |format|
      if @pro_nomina.save
        format.html { redirect_to pro_nomina_url(@pro_nomina), notice: "Pro nomina was successfully created." }
        format.json { render :show, status: :created, location: @pro_nomina }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pro_nomina.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pro_nominas/1 or /pro_nominas/1.json
  def update
    respond_to do |format|
      if @pro_nomina.update(pro_nomina_params)
        format.html { redirect_to pro_nomina_url(@pro_nomina), notice: "Pro nomina was successfully updated." }
        format.json { render :show, status: :ok, location: @pro_nomina }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pro_nomina.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pro_nominas/1 or /pro_nominas/1.json
  def destroy
    @pro_nomina.destroy!

    respond_to do |format|
      format.html { redirect_to pro_nominas_url, notice: "Pro nomina was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pro_nomina
      @pro_nomina = ProNomina.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pro_nomina_params
      params.require(:pro_nomina).permit(:app_nomina_id, :producto_id)
    end
end
