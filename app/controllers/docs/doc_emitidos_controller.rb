class Docs::DocEmitidosController < ApplicationController
  before_action :set_doc_emitido, only: %i[ show edit update destroy update_tipo_factura ]

  layout 'addt'

  # GET /doc_emitidos or /doc_emitidos.json
  def index
    @documentos = DocEmitido.includes(:doc_emitido_detalles)
                             .order(fecha_emision: :desc, folio: :desc)

    # Filtros opcionales
    @documentos = @documentos.por_periodo(params[:anio], params[:mes]) if params[:anio] && params[:mes]
    @documentos = @documentos.por_receptor(params[:rut]) if params[:rut].present?
    @documentos = @documentos.por_tipo(params[:tipo_dte]) if params[:tipo_dte].present?
  end

  # GET /doc_emitidos/1 or /doc_emitidos/1.json
  def show
    @documento = DocEmitido.includes(:cliente, :doc_emitido_detalles, :doc_planilla)
                          .find(params[:id])
  end

  # GET /doc_emitidos/new
  def new
    @objeto = DocEmitido.new
  end

  # GET /doc_emitidos/1/edit
  def edit
  end

  # POST /doc_emitidos or /doc_emitidos.json
  def create
    @objeto = DocEmitido.new(doc_emitido_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Doc emitido was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_emitidos/1 or /doc_emitidos/1.json
  def update
    respond_to do |format|
      if @objeto.update(doc_emitido_params)
        format.html { redirect_to @objeto, notice: "Doc emitido was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_tipo_factura
    if @objeto.update(tipo_factura: params[:tipo_factura])
      redirect_back fallback_location: @objeto.doc_planilla, notice: 'Tipo de factura actualizado.'
    else
      redirect_back fallback_location: @objeto.doc_planilla, alert: 'No se pudo actualizar.'
    end
  end

  # DELETE /doc_emitidos/1 or /doc_emitidos/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @objeto.doc_planilla, status: :see_other, notice: "Doc emitido was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_emitido
      @objeto = DocEmitido.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doc_emitido_params
      params.expect(doc_emitido: [ :nombre_original ])
    end
end
