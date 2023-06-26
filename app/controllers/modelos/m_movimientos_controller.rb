class Modelos::MMovimientosController < ApplicationController
  before_action :set_m_movimiento, only: %i[ show edit update destroy ]

  # GET /m_movimientos or /m_movimientos.json
  def index
    @m_movimientos = MMovimiento.all
  end

  # GET /m_movimientos/1 or /m_movimientos/1.json
  def show
  end

  # GET /m_movimientos/new
  def new
    @m_movimiento = MMovimiento.new
  end

  # GET /m_movimientos/1/edit
  def edit
  end

  # POST /m_movimientos or /m_movimientos.json
  def create
    @m_movimiento = MMovimiento.new(m_movimiento_params)

    respond_to do |format|
      if @m_movimiento.save
        format.html { redirect_to @m_movimiento, notice: "M movimiento was successfully created." }
        format.json { render :show, status: :created, location: @m_movimiento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @m_movimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_movimientos/1 or /m_movimientos/1.json
  def update
    respond_to do |format|
      if @m_movimiento.update(m_movimiento_params)
        format.html { redirect_to @m_movimiento, notice: "M movimiento was successfully updated." }
        format.json { render :show, status: :ok, location: @m_movimiento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @m_movimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /m_movimientos/1 or /m_movimientos/1.json
  def destroy
    @m_movimiento.destroy
    respond_to do |format|
      format.html { redirect_to m_movimientos_url, notice: "M movimiento was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_movimiento
      @m_movimiento = MMovimiento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def m_movimiento_params
      params.require(:m_movimiento).permit(:fecha, :glosa, :m_item_id, :monto)
    end
end
