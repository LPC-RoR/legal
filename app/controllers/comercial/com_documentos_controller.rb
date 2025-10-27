class Comercial::ComDocumentosController < ApplicationController
  before_action :authenticate_usuario!, except: :show_pdf
  before_action :scrty_on
  before_action :require_admin!, except: :show_pdf
  before_action :set_com_documento, only: %i[ show edit update download destroy show_pdf ]

  # GET /com_documentos or /com_documentos.json
  def index
    set_pgnt_tbl('com_documentos', ComDocumento.all.order(issued_on: :desc))
  end

  # GET /com_documentos/1 or /com_documentos/1.json
  def show_pdf
    archivo = ComDocumento.find(params[:id])
    # importante: disposition: :inline
    send_data archivo.file.download,
              filename:    archivo.file.filename.to_s,
              type:        'application/pdf',
              disposition: 'inline'
  end

  # Descarga segura (URL firmada)
  def download
    redirect_to @document.file.url(disposition: :attachment)
  end

  # GET /com_documentos/new
  def new
    @objeto = ComDocumento.new
  end

  # GET /com_documentos/1/edit
  def edit
  end

  # POST /com_documentos or /com_documentos.json
  def create
    @objeto = ComDocumento.new(com_documento_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to com_documentos_path, notice: "Documento comercial fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /com_documentos/1 or /com_documentos/1.json
  def update
    respond_to do |format|
      if @objeto.update(com_documento_params)
        format.html { redirect_to com_documentos_path, notice: "Documento comercial fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /com_documentos/1 or /com_documentos/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to com_documentos_path, status: :see_other, notice: "Documento comercial fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    def require_admin!
      # adapta esto a tu autenticación (Devise, etc.)
      redirect_to(root_path, alert: "No autorizado") unless dog?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_com_documento
      @objeto = ComDocumento.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def com_documento_params
      params.expect(com_documento: [ :codigo, :titulo, :doc_type, :issued_on, :file])
    end
end
