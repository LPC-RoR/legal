class Dt::DtMultasController < ApplicationController
  before_action :set_dt_multa, only: %i[ show edit update destroy ]

  # GET /dt_multas or /dt_multas.json
  def index
    @coleccion = DtMulta.all
  end

  # GET /dt_multas/1 or /dt_multas/1.json
  def show
  end

  # GET /dt_multas/new
  def new
    @objeto = DtMulta.new(dt_infraccion_id: params[:dt_infraccion_id])
  end

  # GET /dt_multas/1/edit
  def edit
  end

  # POST /dt_multas or /dt_multas.json
  def create
    @objeto = DtMulta.new(dt_multa_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Multa fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dt_multas/1 or /dt_multas/1.json
  def update
    respond_to do |format|
      if @objeto.update(dt_multa_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Multa fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dt_multas/1 or /dt_multas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Multa fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dt_multa
      @objeto = DtMulta.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.dt_infraccion
    end

    # Only allow a list of trusted parameters through.
    def dt_multa_params
      params.require(:dt_multa).permit(:orden, :tamanio, :leve, :grave, :gravisima, :dt_infraccion_id)
    end
end
