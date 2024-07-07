class Csc::TipoCausasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tipo_causa, only: %i[ show edit update destroy add_rcrd ]

  # GET /tipo_causas or /tipo_causas.json
  def index
  end

  # GET /tipo_causas/1 or /tipo_causas/1.json
  def show
  end

  # GET /tipo_causas/new
  def new
    @objeto = TipoCausa.new
  end

  # GET /tipo_causas/1/edit
  def edit
  end

  # POST /tipo_causas or /tipo_causas.json
  def create
    @objeto = TipoCausa.new(tipo_causa_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tipo de Causa fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_causas/1 or /tipo_causas/1.json
  def update
    respond_to do |format|
      if @objeto.update(tipo_causa_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tipo de Causa fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_rcrd
    if params[:v_nm].present?
      chld = Variable.find_by(variable: params[:v_nm].split('_').join(' '))
      unless chld.blank?
        @objeto.variables << chld
      end
    end

    redirect_to '/tablas/tipos'
  end

  # DELETE /tipo_causas/1 or /tipo_causas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tipo de Causa fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_causa
      @objeto = TipoCausa.find(params[:id])
    end

    def set_redireccion
      @redireccion = tabla_path(@objeto)
    end

    # Only allow a list of trusted parameters through.
    def tipo_causa_params
      params.require(:tipo_causa).permit(:tipo_causa)
    end
end
