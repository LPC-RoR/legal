class Modelos::MCuentasController < ApplicationController
  before_action :set_m_cuenta, only: %i[ show edit update destroy set_formato ]

  # GET /m_cuentas or /m_cuentas.json
  def index
    @coleccion = MCuenta.all
  end

  # GET /m_cuentas/1 or /m_cuentas/1.json
  def show
  end

  # GET /m_cuentas/new
  def new
#    owner = MBanco.find(params[:m_banco_id])
    @objeto = MCuenta.new(m_modelo_id: params[:oid])
  end

  # GET /m_cuentas/1/edit
  def edit
  end

  # POST /m_cuentas or /m_cuentas.json
  def create
    @objeto = MCuenta.new(m_cuenta_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Cuenta fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_cuentas/1 or /m_cuentas/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_cuenta_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Cuenta fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_formato
    unless params[:set_formato][:m_formato_id].blank?
      @objeto.m_formato_id = params[:set_formato][:m_formato_id]
      @objeto.save
    end

    redirect_to "/tablas/modelo"
  end

  # DELETE /m_cuentas/1 or /m_cuentas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Cuenta fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_cuenta
      @objeto = MCuenta.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/tablas/modelo"
    end

    # Only allow a list of trusted parameters through.
    def m_cuenta_params
      params.require(:m_cuenta).permit(:m_cuenta, :m_banco_id, :m_formato_id, :m_modelo_id)
    end
end
