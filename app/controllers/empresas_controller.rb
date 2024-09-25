class EmpresasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_empresa, only: %i[ show edit update destroy ]

  # GET /empresas or /empresas.json
  def index
    @coleccion = Empresa.all
  end

  # GET /empresas/1 or /empresas/1.json
  def show
  end

  # GET /empresas/new
  def new
    @objeto = Empresa.new
  end

  # GET /empresas/1/edit
  def edit
  end

  # POST /empresas or /empresas.json
  def create
    @objeto = Empresa.new(empresa_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to empresa_url(@objeto), notice: "Empresa was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /empresas/1 or /empresas/1.json
  def update
    respond_to do |format|
      if @objeto.update(empresa_params)
        format.html { redirect_to empresa_url(@objeto), notice: "Empresa was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /empresas/1 or /empresas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to empresas_url, notice: "Empresa was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_empresa
      @objeto = Empresa.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def empresa_params
      params.require(:empresa).permit(:rut, :razon_social, :email_administrador, :email_verificado, :sha1)
    end
end
