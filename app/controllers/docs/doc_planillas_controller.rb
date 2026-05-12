class Docs::DocPlanillasController < ApplicationController
  before_action :set_doc_planilla, only: %i[ show edit update destroy ]

  layout 'addt'

  # GET /doc_planillas or /doc_planillas.json
  def index
    @planillas = DocPlanilla.order(created_at: :desc)
  end

  # GET /doc_planillas/1 or /doc_planillas/1.json
  def show
    @objeto = DocPlanilla.find(params[:id])
    @documentos = @objeto.doc_emitidos.order(fecha_emision: :desc, folio: :desc)
  end

  # GET /doc_planillas/new
  def new
    @objeto = DocPlanilla.new
  end

  # GET /doc_planillas/1/edit
  def edit
  end

  # POST /doc_planillas or /doc_planillas.json
  def create
    @objeto = DocPlanilla.new(doc_planilla_params)
    @objeto.nombre_original = doc_planilla_params[:archivo].original_filename

    if @objeto.save
      # Procesar en background (o síncrono para desarrollo)
      procesar_planilla(@objeto)
      redirect_to doc_planillas_path, notice: "Planilla cargada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /doc_planillas/1 or /doc_planillas/1.json
  def update
    respond_to do |format|
      if @objeto.update(doc_planilla_params)
        format.html { redirect_to @objeto, notice: "Doc planilla was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def procesar
    @objeto = DocPlanilla.find(params[:id])

    if @objeto.pendiente?
      begin
        procesar_planilla(@objeto)
        redirect_to doc_planilla_path(@objeto), notice: "Planilla procesada correctamente."
      rescue StandardError => e
        redirect_to doc_planilla_path(@objeto), alert: "Error: #{e.message}"
      end
    else
      redirect_to doc_planilla_path(@objeto), alert: "La planilla ya fue procesada."
    end
  end

  # DELETE /doc_planillas/1 or /doc_planillas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to doc_planillas_path, status: :see_other, notice: "Doc planilla was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def procesar_planilla(planilla)
      processor = PlanillaProcessor.new(planilla)
      processor.procesar!
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_doc_planilla
      @objeto = DocPlanilla.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doc_planilla_params
      params.require(:doc_planilla).permit(:archivo, :mes, :anio, :tipo)
    end
end
