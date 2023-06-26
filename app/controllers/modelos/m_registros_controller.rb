class Modelos::MRegistrosController < ApplicationController
  before_action :set_m_registro, only: %i[ show edit update destroy ]

  # GET /m_registros or /m_registros.json
  def index
    @m_registros = MRegistro.all
  end

  # GET /m_registros/1 or /m_registros/1.json
  def show
  end

  # GET /m_registros/new
  def new
    @m_registro = MRegistro.new
  end

  # GET /m_registros/1/edit
  def edit
  end

  # POST /m_registros or /m_registros.json
  def create
    @m_registro = MRegistro.new(m_registro_params)

    respond_to do |format|
      if @m_registro.save
        format.html { redirect_to @m_registro, notice: "M registro was successfully created." }
        format.json { render :show, status: :created, location: @m_registro }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @m_registro.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_registros/1 or /m_registros/1.json
  def update
    respond_to do |format|
      if @m_registro.update(m_registro_params)
        format.html { redirect_to @m_registro, notice: "M registro was successfully updated." }
        format.json { render :show, status: :ok, location: @m_registro }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @m_registro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /m_registros/1 or /m_registros/1.json
  def destroy
    @m_registro.destroy
    respond_to do |format|
      format.html { redirect_to m_registros_url, notice: "M registro was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_registro
      @m_registro = MRegistro.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def m_registro_params
      params.require(:m_registro).permit(:m_registro, :orden, :m_conciliacion_id, :fecha, :glosa_banco, :glosa, :documento, :monto, :cargo_abono, :saldo)
    end
end
