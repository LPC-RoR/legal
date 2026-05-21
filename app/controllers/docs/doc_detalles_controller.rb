class Docs::DocDetallesController < ApplicationController
  before_action :set_doc_detalle, only: %i[ show edit update destroy ]

  # GET /doc_detalles or /doc_detalles.json
  def index
    @coleccion = DocDetalle.all
  end

  # GET /doc_detalles/1 or /doc_detalles/1.json
  def show
  end

  # GET /doc_detalles/new
  def new
    emtd = DocEmitido.find(params[:bid])
    @objeto = emtd.doc_detalles.new
  end

  # GET /doc_detalles/1/edit
  def edit
  end

  # POST /doc_detalles or /doc_detalles.json
  def create
    @objeto = DocDetalle.new(doc_detalle_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto.doc_emitido, notice: "Doc detalle was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_detalles/1 or /doc_detalles/1.json
  def update
    respond_to do |format|
      if @objeto.update(doc_detalle_params)
        format.html { redirect_to @objeto.doc_emitido, notice: "Doc detalle was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_detalles/1 or /doc_detalles/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @objeto.doc_emitido, status: :see_other, notice: "Doc detalle was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_detalle
      @objeto = DocDetalle.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doc_detalle_params
      params.expect(doc_detalle: [ :doc_emitido_id, :ownr_type, :ownr_id, :tipo_detalle, :fecha_uf, :glosa, :monto :codigo_formula ])
    end
end
