class Pdf::PdfArchivosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_pdf_archivo, only: %i[ show edit update destroy ]

  # GET /pdf_archivos or /pdf_archivos.json
  def index
    @coleccion = PdfArchivo.all
  end

  # GET /pdf_archivos/1 or /pdf_archivos/1.json
  def show
  end

  # GET /pdf_archivos/new
  def new
    @objeto = PdfArchivo.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  # GET /pdf_archivos/1/edit
  def edit
  end

  # POST /pdf_archivos or /pdf_archivos.json
  def create
    @objeto = PdfArchivo.new(pdf_archivo_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Archivo PDF fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pdf_archivos/1 or /pdf_archivos/1.json
  def update
    respond_to do |format|
      if @objeto.update(pdf_archivo_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Archivo PDF fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pdf_archivos/1 or /pdf_archivos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, status: :see_other, notice: "Archivo PDF fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pdf_archivo
      @objeto = PdfArchivo.find(params.expect(:id))
    end

    def get_rdrccn
      @rdrccn = @objeto.ownr
    end

    # Only allow a list of trusted parameters through.
    def pdf_archivo_params
      params.expect(pdf_archivo: [ :ownr_type, :ownr_id, :tipo, :codigo, :nombre, :modelos ])
    end
end
