class Karin::KrnTramitesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :set_krn_tramite, only: %i[ show edit update destroy ]

  # GET /krn_tramites or /krn_tramites.json
  def index
    @clccn = KrnTramite.all
  end

  # GET /krn_tramites/1 or /krn_tramites/1.json
  def show
  end

  # GET /krn_tramites/new
  def new
    dnnc = KrnDenuncia.find(params[:oid])
    @objeto = dnnc.krn_tramites.new(tipo: params[:code])
  end

  # GET /krn_tramites/1/edit
  def edit
  end

  # POST /krn_tramites or /krn_tramites.json
  def create
    @objeto = KrnTramite.new(krn_tramite_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to shw_dnnc_tab_indx(@objeto.krn_denuncia, 0), notice: "Tramite fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_tramites/1 or /krn_tramites/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_tramite_params)
        format.html { redirect_to shw_dnnc_tab_indx(@objeto.krn_denuncia, 0), notice: "Tramite fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_tramites/1 or /krn_tramites/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to shw_dnnc_tab_indx(@objeto.krn_denuncia, 0), status: :see_other, notice: "Tramite fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_tramite
      @objeto = KrnTramite.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def krn_tramite_params
      params.expect(krn_tramite: [ :krn_denuncia_id, :tipo, :numero_solicitud, :fecha_hora ])
    end
end
