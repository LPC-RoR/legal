class Lgl::LglDocumentosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_lgl_documento, only: %i[ show edit update destroy ]
  after_action :read_pdf, only: %i[ create update ]

  include Lgl

  # GET /lgl_documentos or /lgl_documentos.json
  def index
    set_tabla('lgl_documentos', LglDocumento.all.order(:lgl_documento), true)
    set_tabla('lgl_recursos', LglRecurso.all.order(:lgl_recurso), false)
    set_tabla('lgl_entidades', LglEntidad.all.order(:lgl_entidad), false)
    set_tabla('lgl_n_empleados', LglNEmpleado.all.order(:lgl_n_empleados), false)
  end

  # GET /lgl_documentos/1 or /lgl_documentos/1.json
  def show
    set_tabla('lgl_parrafos', @objeto.lgl_parrafos.order(:orden), false)
  end

  # GET /lgl_documentos/new
  def new
    @objeto = LglDocumento.new
  end

  # GET /lgl_documentos/1/edit
  def edit
  end

  # POST /lgl_documentos or /lgl_documentos.json
  def create
    @objeto = LglDocumento.new(lgl_documento_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Documento legal fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_documentos/1 or /lgl_documentos/1.json
  def update
    respond_to do |format|
      if @objeto.update(lgl_documento_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Documento legal fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgl_documentos/1 or /lgl_documentos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Documento legal fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_documento
      @objeto = LglDocumento.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = lgl_documentos_path
    end

    # Only allow a list of trusted parameters through.
    def lgl_documento_params
      params.require(:lgl_documento).permit(:lgl_documento, :tipo, :archivo)
    end
end