class Modelos::MModelosController < ApplicationController
  before_action :set_m_modelo, only: %i[ show edit update destroy ]

  # GET /m_modelos or /m_modelos.json
  def index
    if usuario_signed_in?
      # Repositorio de la plataforma
      general_sha1 = Digest::SHA1.hexdigest("Modelo de Negocios General")
      @modelo_general = MModelo.find_by(m_modelo: general_sha1)
      @modelo_general = MModelo.create(m_modelo: general_sha1) if @modelo_general.blank?

      # Repositorio_perfil
#      if perfil_activo.modelo_perfil.blank?
#        @modelo_perfil = MModelo.create(m_modelo: perfil_activo.email, ownr_class: 'AppPerfil', ownr_id: perfil_activo.id)
#      else
#        @modelo_perfil = perfil_activo.modelo_perfil
#      end

      init_tabla('general-m_conceptos', @modelo_general.m_conceptos.order(:orden), false)
      add_tabla('general-m_bancos', @modelo_general.m_bancos.order(:m_banco), false) 
      add_tabla('general-m_periodos', @modelo_general.m_periodos.order(clave: :desc), false) 
#      add_tabla('perfil-m_conceptos', @modelo_perfil.m_conceptos.order(:orden), false)
#      add_tabla('perfil-m_bancos', @modelo_perfil.m_bancos.order(:m_banco), false)
#      add_tabla('perfil-m_periodos', @modelo_perfil.m_periodos.order(clave: :desc), false)
    end
  end

  # GET /m_modelos/1 or /m_modelos/1.json
  def show
  end

  # GET /m_modelos/new
  def new
    @objeto = MModelo.new
  end

  # GET /m_modelos/1/edit
  def edit
  end

  # POST /m_modelos or /m_modelos.json
  def create
    @objeto = MModelo.new(m_modelo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Modelo fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_modelos/1 or /m_modelos/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_modelo_params)
        format.html { redirect_to @objeto, notice: "Modelo fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /m_modelos/1 or /m_modelos/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to m_modelos_url, notice: "Modelo fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_modelo
      @objeto = MModelo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def m_modelo_params
      params.require(:m_modelo).permit(:m_modelo, :ownr_class, :ownr_id)
    end
end
