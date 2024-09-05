class Repositorios::RepArchivosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_rep_archivo, only: %i[ show edit update destroy ]

  # GET /rep_archivos or /rep_archivos.json
  def index
    @coleccion = RepArchivo.all
  end

  # GET /rep_archivos/1 or /rep_archivos/1.json
  def show
  end

  # GET /rep_archivos/new
  def new
    rep_doc_controlado = params[:dcid].blank? ? nil : RepDocControlado.find(params[:dcid]).rep_doc_controlado
    ownr = params[:oclss].constantize.find(params[:oid])
    @objeto = ownr.rep_archivos.new(rep_archivo: rep_doc_controlado, rep_doc_controlado_id: params[:dcid])
  end

  # GET /rep_archivos/1/edit
  def edit
  end

  # POST /rep_archivos or /rep_archivos.json
  def create
    @objeto = RepArchivo.new(rep_archivo_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Archivo fue exitósamente creado." }
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
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Archivo fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rep_archivos/1 or /rep_archivos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Archivo fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rep_archivo
      @objeto = RepArchivo.find(params[:id])
    end

    def get_rdrccn
      case @objeto.ownr.class.name
      when 'KrnDenuncia'
        @rdrccn = @objeto.ownr
      when 'KrnDenunciante'
        @rdrccn = @objeto.ownr.krn_denuncia
      end
    end

    # Only allow a list of trusted parameters through.
    def rep_archivo_params
      params.require(:rep_archivo).permit(:ownr_id, :ownr_type, :rep_archivo, :archivo, :rep_doc_controlado_id)
    end
end