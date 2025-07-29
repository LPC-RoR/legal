class Repositorios::RepArchivosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_rep_archivo, only: %i[ show edit update destroy ]
  before_action :set_bck_rdrccn, only:  %i[ edit update destroy ]

  # GET /rep_archivos or /rep_archivos.json
  def index
#    set_tabla('rep_archivos', RepArchivo.hm_archvs, true)
  end

  # GET /rep_archivos/1 or /rep_archivos/1.json
  def show
  end

  # GET /rep_archivos/new
  def new
    dc = params[:dcid].blank? ? nil : RepDocControlado.find(params[:dcid])
    dc_name = dc.blank? ? nil : dc.rep_doc_controlado
    control_fecha = dc.blank? ? nil : dc.control_fecha
    fecha = control_fecha ? Time.zone.now : nil
    chequeable = dc.blank? ? nil : dc.chequeable
    ownr = params[:oclss].constantize.find(params[:oid])
    @objeto = ownr.rep_archivos.new(rep_archivo: dc_name, rep_doc_controlado_id: params[:dcid], control_fecha: control_fecha, chequeable: chequeable, fecha: fecha )
    set_bck_rdrccn
  end

  # GET /rep_archivos/1/edit
  def edit
  end

  # POST /rep_archivos or /rep_archivos.json
  def create
    @objeto = RepArchivo.new(rep_archivo_params)
    set_bck_rdrccn

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to params[:bck_rdrccn], notice: "Archivo fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rep_archivos/1 or /rep_archivos/1.json
  def update
    respond_to do |format|
      if @objeto.update(rep_archivo_params)
        format.html { redirect_to params[:bck_rdrccn], notice: "Archivo fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rep_archivos/1 or /rep_archivos/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @bck_rdrccn, notice: "Archivo fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rep_archivo
      @objeto = RepArchivo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rep_archivo_params
      params.require(:rep_archivo).permit(:ownr_id, :ownr_type, :rep_archivo, :archivo, :archivo_cache, :rep_doc_controlado_id, :nombre, :fecha, :control_fecha, :chequeable)
    end
end
