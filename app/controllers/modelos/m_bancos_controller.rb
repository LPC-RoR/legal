class Modelos::MBancosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_m_banco, only: %i[ show edit update destroy ]

  # GET /m_bancos or /m_bancos.json
  def index
    @coleccion = MBanco.all
  end

  # GET /m_bancos/1 or /m_bancos/1.json
  def show
    set_tabla('m_cuentas', @objeto.m_cuentas.order(:m_cuenta), false)
    set_tabla('m_formatos', @objeto.m_formatos.order(:m_formato), false)
  end

  # GET /m_bancos/new
  def new
    @objeto = MBanco.new(m_modelo_id: params[:objeto_id])
  end

  # GET /m_bancos/1/edit
  def edit
  end

  # POST /m_bancos or /m_bancos.json
  def create
    @objeto = MBanco.new(m_banco_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Banco fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_bancos/1 or /m_bancos/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_banco_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Banco fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /m_bancos/1 or /m_bancos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Banco fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_banco
      @objeto = MBanco.find(params[:id])
    end

    def set_redireccion
      @redireccion = tabla_path(@objeto)
    end

    # Only allow a list of trusted parameters through.
    def m_banco_params
      params.require(:m_banco).permit(:m_banco, :m_modelo_id)
    end
end
