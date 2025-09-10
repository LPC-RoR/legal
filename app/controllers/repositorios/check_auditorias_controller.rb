class Repositorios::CheckAuditoriasController < ApplicationController
  before_action :set_check_auditoria, only: %i[ show edit update destroy ]

  # GET /check_auditorias or /check_auditorias.json
  def index
    @coleccion = CheckAuditoria.all
  end

  # GET /check_auditorias/1 or /check_auditorias/1.json
  def show
  end

  # GET /check_auditorias/new
  def new
    @objeto = CheckAuditoria.new
  end

  # GET /check_auditorias/1/edit
  def edit
  end

  # POST /check_auditorias or /check_auditorias.json
  def create
    @objeto = CheckAuditoria.new(check_auditoria_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Auditoria fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /check_auditorias/1 or /check_auditorias/1.json
  def update
    respond_to do |format|
      if @objeto.update(check_auditoria_params)
        format.html { redirect_to @objeto, notice: "Auditoria fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_auditorias/1 or /check_auditorias/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to check_auditorias_path, status: :see_other, notice: "Auditoria fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_auditoria
      @objeto = CheckAuditoria.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def check_auditoria_params
      params.expect(check_auditoria: [ :ownr_type, :ownr_id, :mdl, :cdg, :prsnt, :audited_at, :app_perfil_id ])
    end
end
