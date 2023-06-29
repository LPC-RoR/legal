class MValoresController < ApplicationController
  before_action :set_m_valor, only: %i[ show edit update destroy ]

  # GET /m_valores or /m_valores.json
  def index
    @coleccion = MValor.all
  end

  # GET /m_valores/1 or /m_valores/1.json
  def show
  end

  # GET /m_valores/new
  def new
    @objeto = MValor.new
  end

  # GET /m_valores/1/edit
  def edit
  end

  # POST /m_valores or /m_valores.json
  def create
    @objeto = MValor.new(m_valor_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "M valor was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_valores/1 or /m_valores/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_valor_params)
        format.html { redirect_to @objeto, notice: "M valor was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /m_valores/1 or /m_valores/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to m_valores_url, notice: "M valor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_valor
      @objeto = MValor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def m_valor_params
      params.require(:m_valor).permit(:orden, :m_valor, :tipo, :valor, :m_conciliacion_id)
    end
end
