class Repositorios::AuditNotasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_audit_nota, only: %i[ show edit update destroy ]

  # GET /audit_notas or /audit_notas.json
  def index
    @coleccion = AuditNota.all
  end

  # GET /audit_notas/1 or /audit_notas/1.json
  def show
  end

  # GET /audit_notas/new
  def new
    @objeto = AuditNota.new(ownr_type: params[:oclss], ownr_id: params[:oid], app_perfil_id: perfil_activo.id, prioridad: 3)
  end

  # GET /audit_notas/1/edit
  def edit
  end

  # POST /audit_notas or /audit_notas.json
  def create
    @objeto = AuditNota.new(audit_nota_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Audit nota was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /audit_notas/1 or /audit_notas/1.json
  def update
    respond_to do |format|
      if @objeto.update(audit_nota_params)
        format.html { redirect_to @objeto, notice: "Audit nota was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /audit_notas/1 or /audit_notas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to audit_notas_path, status: :see_other, notice: "Audit nota was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audit_nota
      @objeto = AuditNota.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def audit_nota_params
      params.expect(audit_nota: [ :ownr_type, :ownr_id, :app_perfil_id, :nota, :recomendacion, :prioridad ])
    end
end
