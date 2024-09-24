class Karin::KrnInvestigadoresController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_investigador, only: %i[ show edit update destroy ]

  # GET /krn_investigadores or /krn_investigadores.json
  def index
    set_tabla('krn_investigadores', KrnInvestigador.ordr, false)
  end

  # GET /krn_investigadores/1 or /krn_investigadores/1.json
  def show
  end

  # GET /krn_investigadores/new
  def new
    cliente_id = params[:oclss] == 'Cliente' ? params[:oid] : nil
    empresa_id = params[:oclss] == 'Cliente' ? nil : params[:oid]
    @objeto = KrnInvestigador.new(cliente_id: cliente_id, empresa_id: empresa_id)
  end

  # GET /krn_investigadores/1/edit
  def edit
  end

  # POST /krn_investigadores or /krn_investigadores.json
  def create
    @objeto = KrnInvestigador.new(krn_investigador_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Investigador fue exitósamente creado." }
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
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Investigador fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_investigadores/1 or /krn_investigadores/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Investigador fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_investigador
      @objeto = KrnInvestigador.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = "/clientes/#{@objeto.cliente_id}?html_options[menu]=Investigaciones"
    end

    # Only allow a list of trusted parameters through.
    def krn_investigador_params
      params.require(:krn_investigador).permit(:krn_investigador, :rut, :email, :cliente_id, :empresa_id)
    end
end
