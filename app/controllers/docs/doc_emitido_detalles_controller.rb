class Docs::DocEmitidoDetallesController < ApplicationController
  before_action :set_doc_emitido_detalle, only: %i[ show edit update destroy ]

  layout 'addt'

  # GET /doc_emitido_detalles or /doc_emitido_detalles.json
  def index
    @doc_emitido_detalles = DocEmitidoDetalle.all
  end

  # GET /doc_emitido_detalles/1 or /doc_emitido_detalles/1.json
  def show
  end

  # GET /doc_emitido_detalles/new
  def new
    @doc_emitido_detalle = DocEmitidoDetalle.new
  end

  # GET /doc_emitido_detalles/1/edit
  def edit
  end

  # POST /doc_emitido_detalles or /doc_emitido_detalles.json
  def create
    @doc_emitido_detalle = DocEmitidoDetalle.new(doc_emitido_detalle_params)

    respond_to do |format|
      if @doc_emitido_detalle.save
        format.html { redirect_to @doc_emitido_detalle, notice: "Doc emitido detalle was successfully created." }
        format.json { render :show, status: :created, location: @doc_emitido_detalle }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @doc_emitido_detalle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_emitido_detalles/1 or /doc_emitido_detalles/1.json
  def update
    respond_to do |format|
      if @doc_emitido_detalle.update(doc_emitido_detalle_params)
        format.html { redirect_to @doc_emitido_detalle, notice: "Doc emitido detalle was successfully updated." }
        format.json { render :show, status: :ok, location: @doc_emitido_detalle }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @doc_emitido_detalle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_emitido_detalles/1 or /doc_emitido_detalles/1.json
  def destroy
    @doc_emitido_detalle.destroy!

    respond_to do |format|
      format.html { redirect_to doc_emitido_detalles_path, status: :see_other, notice: "Doc emitido detalle was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_emitido_detalle
      @doc_emitido_detalle = DocEmitidoDetalle.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doc_emitido_detalle_params
      params.expect(doc_emitido_detalle: [ :nombre_original ])
    end
end
