class Karin::KrnDenunciantesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denunciante, only: %i[ show edit update destroy swtch rlzd prsnt set_fld clear_fld ]

  include ProcControl
  include Karin

  # GET /krn_denunciantes or /krn_denunciantes.json
  def index
    @coleccion = KrnDenunciante.all
  end

  # GET /krn_denunciantes/1 or /krn_denunciantes/1.json
  def show
  end

  # GET /krn_denunciantes/new
  def new
    @objeto = KrnDenunciante.new(krn_denuncia_id: params[:oid])
    set_bck_rdrccn
  end

  # GET /krn_denunciantes/1/edit
  def edit
  end

  # POST /krn_denunciantes or /krn_denunciantes.json
  def create
    @objeto = KrnDenunciante.new(krn_denunciante_params)
    set_bck_rdrccn

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to dnnc_shw_path(@objeto), notice: "Denunciante fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_denunciantes/1 or /krn_denunciantes/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_denunciante_params)
        format.html { redirect_to dnnc_shw_path(@objeto), notice: "Denunciante fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_denunciantes/1 or /krn_denunciantes/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to dnnc_shw_path(@objeto), notice: "Denunciante fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_denunciante
      @objeto = KrnDenunciante.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_denunciante_params
      params.require(:krn_denunciante).permit(:krn_denuncia_id, :krn_empresa_externa_id, :rut, :nombre, :cargo, :lugar_trabajo, :email, :email_ok, :articulo_4_1, :articulo_516, :direccion_notificacion, :representante, :empleado_externo)
    end
end
