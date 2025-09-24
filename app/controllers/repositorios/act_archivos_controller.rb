class Repositorios::ActArchivosController < ApplicationController
  before_action :set_act_archivo, only: %i[ show edit update destroy download rmv_cntrld ]
  before_action :authenticate_usuario!
  before_action :scrty_on

  include Paths

  # GET /act_archivos or /act_archivos.json
  def index
    @coleccion = ActArchivo.all
  end

  # GET /act_archivos/1 or /act_archivos/1.json
  def show
  end

  def download
    doc = ActArchivo.find(params[:id])
    authorize! :read, doc if defined?(authorize!) # opcional
    redirect_to rails_blob_url(doc.pdf, disposition: "attachment")
  end

  # GET /act_archivos/new
  def new
    @objeto = ActArchivo.new(ownr_type: params[:oclss], ownr_id: params[:oid], act_archivo: params[:act], mdl: params[:mdl], control_fecha: params[:control_fecha])
  end

  # GET /act_archivos/1/edit
  def edit
  end

  # POST /act_archivos or /act_archivos.json
  def create
    @objeto = ActArchivo.new(act_archivo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to act_archivo_rdrccn(@objeto.ownr), notice: "Archivo fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /act_archivos/1 or /act_archivos/1.json
  def update
    respond_to do |format|
      if @objeto.update(act_archivo_params)
        format.html { redirect_to act_archivo_rdrccn(@objeto.ownr), notice: "Archivo fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /act_archivos/1 or /act_archivos/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to act_archivo_rdrccn(@objeto.ownr), status: :see_other, notice: "Archivo fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  def rmv_cntrld
    pdf_registro = @objeto.ownr.pdf_registros.find_by(cdg: @objeto.act_archivo)
    pdf_registro.delete unless pdf_registro.blank?
    @objeto.delete

    redirect_to act_archivo_rdrccn(@objeto.ownr)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_act_archivo
      @objeto = ActArchivo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def act_archivo_params
      params.expect(act_archivo: [ :ownr_type, :ownr_id, :act_archivo, :mdl, :control_fecha, :nombre, :fecha, :pdf, :rlzd ])
    end
end
