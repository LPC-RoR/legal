class Control::CtrPasosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_ctr_paso, only: %i[ show edit update destroy arriba abajo ]

  include Orden

  # GET /ctr_pasos or /ctr_pasos.json
  def index
    @coleccion = CtrPaso.all
  end

  # GET /ctr_pasos/1 or /ctr_pasos/1.json
  def show
  end

  # GET /ctr_pasos/new
  def new
    tar = Tarea.find(params[:oid])
    orden = tar.ctr_pasos.count + 1
    @objeto = CtrPaso.new(orden: orden, tarea_id: params[:oid])
  end

  # GET /ctr_pasos/1/edit
  def edit
  end

  # POST /ctr_pasos or /ctr_pasos.json
  def create
    @objeto = CtrPaso.new(ctr_paso_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Paso fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ctr_pasos/1 or /ctr_pasos/1.json
  def update
    respond_to do |format|
      if @objeto.update(ctr_paso_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Paso fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ctr_pasos/1 or /ctr_pasos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, status: :see_other, notice: "Paso fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ctr_paso
      @objeto = CtrPaso.find(params.expect(:id))
    end

    def get_rdrccn
      @rdrccn = @objeto.tarea
    end

    # Only allow a list of trusted parameters through.
    def ctr_paso_params
      params.expect(ctr_paso: [ :orden, :tarea_id, :codigo, :glosa, :metodo, :blngs_metodo, :rght ])
    end
end
