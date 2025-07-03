class Karin::KrnInvestigadoresController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_investigador, only: %i[ show edit update destroy ]
  before_action :set_bck_rdrccn

  # GET /krn_investigadores or /krn_investigadores.json
  def index
    set_tabla('krn_investigadores', KrnInvestigador.ordr, false)
  end

  # GET /krn_investigadores/1 or /krn_investigadores/1.json
  def show
  end

  # GET /krn_investigadores/new
  def new
    @objeto = KrnInvestigador.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  # GET /krn_investigadores/1/edit
  def edit
  end

  # POST /krn_investigadores or /krn_investigadores.json
  def create
    @objeto = KrnInvestigador.new(krn_investigador_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to params[:bck_rdrccn], notice: "Investigador fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_investigadores/1 or /krn_investigadores/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_investigador_params)
        format.html { redirect_to params[:bck_rdrccn], notice: "Investigador fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_investigadores/1 or /krn_investigadores/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to params[:bck_rdrccn], notice: "Investigador fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_investigador
      @objeto = KrnInvestigador.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_investigador_params
      params.require(:krn_investigador).permit(:krn_investigador, :rut, :email, :ownr_type, :ownr_id)
    end
end
