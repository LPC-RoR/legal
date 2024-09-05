class Karin::KrnLstModificacionesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_lst_modificacion, only: %i[ show edit update destroy ]

  # GET /krn_lst_modificaciones or /krn_lst_modificaciones.json
  def index
    @coleccion = KrnLstModificacion.all
  end

  # GET /krn_lst_modificaciones/1 or /krn_lst_modificaciones/1.json
  def show
   set_tabla('krn_modificaciones', @objeto.krn_modificaciones.ordr, false)
  end

  # GET /krn_lst_modificaciones/new
  def new
    @objeto = KrnLstModificacion.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  # GET /krn_lst_modificaciones/1/edit
  def edit
  end

  # POST /krn_lst_modificaciones or /krn_lst_modificaciones.json
  def create
    @objeto = KrnLstModificacion.new(krn_lst_modificacion_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Lista de modificaciones fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_lst_modificaciones/1 or /krn_lst_modificaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_lst_modificacion_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Lista de modificaciones fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_lst_modificaciones/1 or /krn_lst_modificaciones/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Lista de modificaciones fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_lst_modificacion
      @objeto = KrnLstModificacion.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.ownr.krn_denuncia
    end

    # Only allow a list of trusted parameters through.
    def krn_lst_modificacion_params
      params.require(:krn_lst_modificacion).permit(:ownr_id, :ownr_type, :emisor)
    end
end
