class Karin::KrnModificacionesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_modificacion, only: %i[ show edit update destroy ]

  # GET /krn_modificaciones or /krn_modificaciones.json
  def index
    @coleccion = KrnModificacion.all
  end

  # GET /krn_modificaciones/1 or /krn_modificaciones/1.json
  def show
  end

  # GET /krn_modificaciones/new
  def new
  end

  def nueva
    lst = KrnLstModificacion.find(params[:oid])
    mod = lst.krn_modificaciones.create(krn_medida_id: params[:mid])

    redirect_to lst
  end

  # GET /krn_modificaciones/1/edit
  def edit
  end

  # POST /krn_modificaciones or /krn_modificaciones.json
  def create
    @objeto = KrnModificacion.new(krn_modificacion_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Modificacion fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_modificaciones/1 or /krn_modificaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_modificacion_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Modificacion fue exitósamente modificada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_modificaciones/1 or /krn_modificaciones/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Modificacion fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_modificacion
      @objeto = KrnModificacion.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.krn_lst_modificacion
    end

    # Only allow a list of trusted parameters through.
    def krn_modificacion_params
      params.require(:krn_modificacion).permit(:krn_lst_modificacion_id, :krn_medida_id, :detalle)
    end
end
