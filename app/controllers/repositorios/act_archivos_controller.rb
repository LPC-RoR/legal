class Repositorios::ActArchivosController < ApplicationController
  before_action :set_act_archivo, only: %i[ show_pdf edit update destroy download rmv_cntrld annmzr ]
  before_action :authenticate_usuario!
  before_action :scrty_on

  include Paths

  # GET /act_archivos or /act_archivos.json
  def index
    @coleccion = ActArchivo.all
  end

  # GET /act_archivos/1 or /act_archivos/1.json
  def show_pdf
    archivo = ActArchivo.find(params[:id])
    # importante: disposition: :inline
    send_data archivo.pdf.download,
              filename:    archivo.pdf.filename.to_s,
              type:        'application/pdf',
              disposition: 'inline'
  end

  def download
    doc = ActArchivo.find(params[:id])
    authorize doc

    unless doc.pdf.attached?
      redirect_back fallback_location: root_path, alert: 'Archivo no disponible'
      return                # <── important
    end

    redirect_to rails_blob_url(doc.pdf, disposition: 'attachment')
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
        format.html { redirect_to act_archivo_rdrccn(@objeto), notice: "Archivo fue exitosamente creado." }
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
        format.html { redirect_to act_archivo_rdrccn(@objeto), notice: "Archivo fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def annmzr
    if @objeto
      AnonimizaPdfJob.perform_later(@objeto.id, @objeto.pdf.blob.id)
      ntc = 'Anonimización en curso. El nuevo archivo aparecerá en segundos.'
    else
      ntc = 'Archivo fuente no encontrado'
    end

    redirect_to "/krn_denuncias/#{@objeto.ownr.dnnc.id}_#{@objeto.act_archivo == 'declaracion' ? 1 : 0}", ntc: ntc
  end

  # DELETE /act_archivos/1 or /act_archivos/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to act_archivo_rdrccn(@objeto), status: :see_other, notice: "Archivo fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  def rmv_cntrld
    pdf_registro = @objeto.ownr.pdf_registros.find_by(cdg: @objeto.act_archivo)
    pdf_registro.delete unless pdf_registro.blank?
    @objeto.delete

    redirect_to act_archivo_rdrccn(@objeto.ownr)
  end

  # Para descargar los archivos generados por OpenAI
  def descargar_archivo_generado
    @act_archivo = ActArchivo.find(params[:id])
    tipo = params[:tipo]
    
    archivo = case tipo
    when 'participantes'
      @act_archivo.lista_participantes
    when 'resumen'
      @act_archivo.resumen_anonimizado
    when 'hechos'
      @act_archivo.lista_hechos
    end

    if archivo.attached?
      redirect_to rails_blob_url(archivo, disposition: "attachment")
    else
      redirect_to @act_archivo, alert: "El archivo no está disponible"
    end
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
