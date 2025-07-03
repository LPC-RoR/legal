class Lgl::LglTramoEmpresasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_lgl_tramo_empresa, only: %i[ show edit update destroy ]

  # GET /lgl_tramo_empresas or /lgl_tramo_empresas.json
  def index
    @coleccion = LglTramoEmpresa.all
  end

  # GET /lgl_tramo_empresas/1 or /lgl_tramo_empresas/1.json
  def show
  end

  # GET /lgl_tramo_empresas/new
  def new
    orden = LglTramoEmpresa.all.count + 1
    @objeto = LglTramoEmpresa.new(orden: orden)
  end

  # GET /lgl_tramo_empresas/1/edit
  def edit
  end

  # POST /lgl_tramo_empresas or /lgl_tramo_empresas.json
  def create
    @objeto = LglTramoEmpresa.new(lgl_tramo_empresa_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tramo de empresa fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_tramo_empresas/1 or /lgl_tramo_empresas/1.json
  def update
    respond_to do |format|
      if @objeto.update(lgl_tramo_empresa_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tramo de empresa fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgl_tramo_empresas/1 or /lgl_tramo_empresas/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Tramo de empresa fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_tramo_empresa
      @objeto = LglTramoEmpresa.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = lgl_documentos_path
    end

    # Only allow a list of trusted parameters through.
    def lgl_tramo_empresa_params
      params.require(:lgl_tramo_empresa).permit(:lgl_tramo_empresa, :min, :max, :orden)
    end
end
