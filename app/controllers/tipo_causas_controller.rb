class TipoCausasController < ApplicationController
  before_action :set_tipo_causa, only: %i[ show edit update destroy ]

  include Sidebar

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
        format.html { redirect_to @redireccion, notice: "Tipo causa was successfully created." }
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
        format.html { redirect_to @redireccion, notice: "Tipo causa was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_causas/1 or /tipo_causas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tipo causa was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_causa
      @objeto = TipoCausa.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/app_recursos/tablas?html_options[tablas]=Tipos+de+Causa" 
    end

    # Only allow a list of trusted parameters through.
    def tipo_causa_params
      params.require(:tipo_causa).permit(:tipo_causa)
    end
end
