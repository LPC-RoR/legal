class Investigacion::DenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_denuncia, only: %i[ show edit update destroy ]

  include Plazos

  # GET /denuncias or /denuncias.json
  def index
    @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

    @modelo = StModelo.find_by(st_modelo: 'Denuncia')
    @estados = @modelo.blank? ? [] : @modelo.st_estados.order(:orden).map {|e_ase| e_ase.st_estado}
    @tipos = nil

    v_first = get_first_es('denuncias')
    frst_e = (v_first[0] == 'estado') ? v_first[1] : nil
    frst_s = (v_first[0] == 'selector') ? v_first[1] : nil

    @estado = (params[:e].blank? and params[:t].blank?) ? frst_e : params[:e]
    @tipo = (params[:t].blank? and @estado.blank?) ? frst_s : params[:t]
    @path = "/denuncias?"
    @link_new = @estado == 'recepcion' ? '/denuncias/new' : nil

#    if params[:query].blank?

      cllcn = Denuncia.where(estado: @estado) if @estado.present?
#      cllcn = Denuncia.where(en_cobranza: true) if (@tipo.present? and @estado.blank?)

      set_tabla('denuncias', cllcn, true)
      @srch = false
#    else
#      @cs_array = Causa.search_for(params[:query])
#      @srch = true
#    end

  end

  # GET /denuncias/1 or /denuncias/1.json
  def show
    set_st_estado(@objeto)
    set_tab( :menu, ['Monitor', ['Denunciados', operacion?], ['Medidas', operacion?], ['Antecedentes', operacion?], ['Informe', operacion?], ['Denuncia', operacion?]] )

    puts "******************************************************** show"
    prueba = Date.today
    p_15 = plz_lv(prueba, 6)
    p2_15 = plz_c(prueba, 6)
    puts p_15
    puts p2_15

    case @options[:menu]
    when 'Monitor'
    when 'Denunciados'
      set_tabla('denunciados', @objeto.denunciados.order(:denunciados), false)
    when 'Medidas'
    when 'Antecedentes'
    when 'Informe'
    when 'Denuncia'
    end
  end

  # GET /denuncias/new
  def new
    modelo_causa = StModelo.find_by(st_modelo: 'Denuncia')
    @objeto = Denuncia.new(estado: modelo_causa.primer_estado.st_estado)
  end

  # GET /denuncias/1/edit
  def edit
  end

  # POST /denuncias or /denuncias.json
  def create
    @objeto = Denuncia.new(denuncia_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denuncia fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /denuncias/1 or /denuncias/1.json
  def update
    respond_to do |format|
      if @objeto.update(denuncia_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denuncia fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /denuncias/1 or /denuncias/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Denuncia fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_denuncia
      @objeto = Denuncia.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = denuncias_path
    end

    # Only allow a list of trusted parameters through.
    def denuncia_params
      params.require(:denuncia).permit(:fecha_hora, :fecha_hora_dt, :empresa_id, :cliente_id, :receptor_denuncia_id, :alcance_denuncia_id, :motivo_denuncia_id, :dependencia_denunciante_id, :empresa_receptora, :denuncia_presencial, :denuncia_verbal, :rut_empresa_denunciante, :empresa_denunciante, :representante, :documento_representacion, :rut, :denunciante, :cargo, :lugar_trabajo, :email, :denunciante_otra_empresa, :destino_derivacion, :causa_derivacion, :estado)
    end
end
