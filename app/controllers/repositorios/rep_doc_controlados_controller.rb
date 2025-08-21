class Repositorios::RepDocControladosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_rep_doc_controlado, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy
  before_action :set_bck_rdrccn, only:  %i[ edit update destroy ]

  include Orden

  # GET /rep_doc_controlados or /rep_doc_controlados.json
  def index
    @coleccion = RepDocControlado.all
  end

  # GET /rep_doc_controlados/1 or /rep_doc_controlados/1.json
  def show
  end

  # GET /rep_doc_controlados/new
  def new
    ownr = params[:oclss].constantize.find(params[:oid])
    orden = ownr.rep_doc_controlados.count + 1
    @objeto = ownr.rep_doc_controlados.new(orden: orden)
    set_bck_rdrccn
  end

  # GET /rep_doc_controlados/1/edit
  def edit
  end

  # POST /rep_doc_controlados or /rep_doc_controlados.json
  def create
    @objeto = RepDocControlado.new(rep_doc_controlado_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @bck_rdrccn, notice: "Documento controlado fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rep_doc_controlados/1 or /rep_doc_controlados/1.json
  def update
    respond_to do |format|
      if @objeto.update(rep_doc_controlado_params)
        format.html { redirect_to @bck_rdrccn, notice: "Documento controlado fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rep_doc_controlados/1 or /rep_doc_controlados/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @bck_rdrccn, notice: "Documento controlado fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rep_doc_controlado
      @objeto = RepDocControlado.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rep_doc_controlado_params
      params.require(:rep_doc_controlado).permit(:ownr_id, :ownr_type, :rep_doc_controlado, :archivo, :tipo, :control, :orden, :codigo, :descripcion, :multiple, :control_fecha, :chequeable)
    end
end
