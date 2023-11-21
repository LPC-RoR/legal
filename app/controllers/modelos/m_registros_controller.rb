class Modelos::MRegistrosController < ApplicationController
  before_action :set_m_registro, only: %i[ show edit update destroy asigna ]

  # GET /m_registros or /m_registros.json
  def index
    @coleccion = MRegistro.all
  end

  # GET /m_registros/1 or /m_registros/1.json
  def show
    init_tabla('tar_facturas', @objeto.tar_facturas,order(:documento, false)
  end

  # GET /m_registros/new
  def new
    @objeto = MRegistro.new
  end

  # GET /m_registros/1/edit
  def edit
  end

  # POST /m_registros or /m_registros.json
  def create
    @objeto = MRegistro.new(m_registro_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Registro fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_registros/1 or /m_registros/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_registro_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Registro fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def asigna
    @objeto.m_item_id = params[:iid]
    @objeto.save

    redirect_to "/m_modelos?id=p_#{@objeto.m_periodo.id}"
  end

  # DELETE /m_registros/1 or /m_registros/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Registro fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_registro
      @objeto = MRegistro.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.periodo
    end

    # Only allow a list of trusted parameters through.
    def m_registro_params
      params.require(:m_registro).permit(:m_registro, :orden, :m_conciliacion_id, :fecha, :glosa_banco, :glosa, :documento, :monto, :cargo_abono, :saldo, :m_item_id)
    end
end
