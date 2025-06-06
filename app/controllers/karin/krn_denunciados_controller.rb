class Karin::KrnDenunciadosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denunciado, only: %i[ show edit update destroy swtch set_fld clear_fld ]

  include ProcControl
  include Karin

  # GET /krn_denunciados or /krn_denunciados.json
  def index
    @coleccion = KrnDenunciado.all
  end

  # GET /krn_denunciados/1 or /krn_denunciados/1.json
  def show
  end

  # GET /krn_denunciados/new
  def new
    @objeto = KrnDenunciado.new(krn_denuncia_id: params[:oid])
  end

  # GET /krn_denunciados/1/edit
  def edit
  end

  # POST /krn_denunciados or /krn_denunciados.json
  def create
    @objeto = KrnDenunciado.new(krn_denunciado_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denunciado fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_denunciados/1 or /krn_denunciados/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_denunciado_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denunciado fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_denunciados/1 or /krn_denunciados/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Denunciado fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_denunciado
      @objeto = KrnDenunciado.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = "/krn_denuncias/#{@objeto.krn_denuncia_id}_1"
    end

    # Only allow a list of trusted parameters through.
    def krn_denunciado_params 
      params.require(:krn_denunciado).permit(:krn_denuncia_id, :krn_empresa_externa_id, :rut, :nombre, :cargo, :lugar_trabajo, :email, :email_ok, :articulo_4_1, :articulo_516, :direccion_notificacion, :empleado_externo, :relacion_denunciante)
    end
end
