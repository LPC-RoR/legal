class Karin::KrnEmpresaExternasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_empresa_externa, only: %i[ show edit update destroy ]
  before_action :set_bck_rdrccn, only:  %i[ edit update destroy ]

  # GET /krn_empresa_externas or /krn_empresa_externas.json
  def index
    @coleccion = KrnEmpresaExterna.all
  end

  # GET /krn_empresa_externas/1 or /krn_empresa_externas/1.json
  def show
  end

  # GET /krn_empresa_externas/new
  def new
    @objeto = KrnEmpresaExterna.new(ownr_type: params[:oclss], ownr_id: params[:oid])
    set_bck_rdrccn
  end

  # GET /krn_empresa_externas/1/edit
  def edit
  end

  # POST /krn_empresa_externas or /krn_empresa_externas.json
  def create
    @objeto = KrnEmpresaExterna.new(krn_empresa_externa_params)
    set_bck_rdrccn

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to params[:bck_rdrccn], notice: "Empresa externa fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_empresa_externas/1 or /krn_empresa_externas/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_empresa_externa_params)
        format.html { redirect_to params[:bck_rdrccn], notice: "Empresa externa fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_empresa_externas/1 or /krn_empresa_externas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @bck_rdrccn, notice: "Empresa externa fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_empresa_externa
      @objeto = KrnEmpresaExterna.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_empresa_externa_params
      params.require(:krn_empresa_externa).permit(:rut, :razon_social, :tipo, :contacto, :email_contacto, :ownr_type, :ownr_id)
    end
end
