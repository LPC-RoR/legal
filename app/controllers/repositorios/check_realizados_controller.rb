class Repositorios::CheckRealizadosController < ApplicationController
  before_action :set_check_realizado, only: %i[ show edit update destroy ]

  # GET /check_realizados or /check_realizados.json
  def index
    @coleccion = CheckRealizado.all
  end

  # GET /check_realizados/1 or /check_realizados/1.json
  def show
  end

  # GET /check_realizados/new
  def new
    @objeto = CheckRealizado.new
  end

  # GET /check_realizados/1/edit
  def edit
  end

  # POST /check_realizados or /check_realizados.json
  def create
    @objeto = CheckRealizado.new(check_realizado_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Chequeo fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /check_realizados/1 or /check_realizados/1.json
  def update
    respond_to do |format|
      if @objeto.update(check_realizado_params)
        format.html { redirect_to @objeto, notice: "Chequeo fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_realizados/1 or /check_realizados/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to check_realizados_path, status: :see_other, notice: "Eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_realizado
      @objeto = CheckRealizado.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def check_realizado_params
      params.expect(check_realizado: [ :ownr_type, :ownr_id, :app_perfil_id, :mdl, :cdg, :rlzd, :chequed_at ])
    end
end
