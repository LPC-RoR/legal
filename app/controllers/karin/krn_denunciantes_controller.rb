class Karin::KrnDenunciantesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denunciante, only: %i[ show edit update destroy swtch set_fld clear_fld ]

  include ProcControl
  include Karin

  # GET /krn_denunciantes or /krn_denunciantes.json
  def index
    @coleccion = KrnDenunciante.all
  end

  # GET /krn_denunciantes/1 or /krn_denunciantes/1.json
  def show
    #load_proc(@objeto)
    @etps = Procedimiento.prcdmnt('krn_invstgcn').ctr_etapas.ordr
    @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

    set_tabla('krn_declaraciones', @objeto.krn_declaraciones, false)
    set_tabla('krn_testigos', @objeto.krn_testigos, false)
    set_tabla('ctr_registros', @objeto.ctr_registros, false)
  end

  # GET /krn_denunciantes/new
  def new
    @objeto = KrnDenunciante.new(krn_denuncia_id: params[:oid])
  end

  # GET /krn_denunciantes/1/edit
  def edit
  end

  # POST /krn_denunciantes or /krn_denunciantes.json
  def create
    @objeto = KrnDenunciante.new(krn_denunciante_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denunciante fue exitósamente creado." }
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
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denunciante fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_denunciantes/1 or /krn_denunciantes/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Denunciante fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_denunciante
      @objeto = KrnDenunciante.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = "/krn_denuncias/#{@objeto.krn_denuncia_id}_1"
    end

    # Only allow a list of trusted parameters through.
    def krn_denunciante_params
      params.require(:krn_denunciante).permit(:krn_denuncia_id, :krn_empresa_externa_id, :rut, :nombre, :cargo, :lugar_trabajo, :email, :email_ok, :articulo_4_1, :articulo_516, :direccion_notificacion, :representante, :empleado_externo)
    end
end
