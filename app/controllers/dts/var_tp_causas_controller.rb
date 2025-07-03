class Dts::VarTpCausasController < ApplicationController
  before_action :set_var_tp_causa, only: %i[ show edit update destroy ]

  # GET /var_tp_causas or /var_tp_causas.json
  def index
    @var_tp_causas = VarTpCausa.all
  end

  # GET /var_tp_causas/1 or /var_tp_causas/1.json
  def show
  end

  # GET /var_tp_causas/new
  def new
    @var_tp_causa = VarTpCausa.new
  end

  # GET /var_tp_causas/1/edit
  def edit
  end

  # POST /var_tp_causas or /var_tp_causas.json
  def create
    @var_tp_causa = VarTpCausa.new(var_tp_causa_params)

    respond_to do |format|
      if @var_tp_causa.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "---." }
        format.json { render :show, status: :created, location: @var_tp_causa }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @var_tp_causa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /var_tp_causas/1 or /var_tp_causas/1.json
  def update
    respond_to do |format|
      if @var_tp_causa.update(var_tp_causa_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "---." }
        format.json { render :show, status: :ok, location: @var_tp_causa }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @var_tp_causa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /var_tp_causas/1 or /var_tp_causas/1.json
  def destroy
    set_redireccion
    @var_tp_causa.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Variable fue exitosamente liberada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_var_tp_causa
      @var_tp_causa = VarTpCausa.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/tablas/tipos"
    end

    # Only allow a list of trusted parameters through.
    def var_tp_causa_params
      params.require(:var_tp_causa).permit(:variable_id, :tipo_causa_id)
    end
end
