class Docs::DocBoletasController < ApplicationController
  before_action :set_doc_boleta, only: %i[ show edit update destroy ]

  layout 'addt'

  # GET /doc_boletas or /doc_boletas.json
  def index
    @clccn = DocBoleta.all
  end

  # GET /doc_boletas/1 or /doc_boletas/1.json
  def show
  end

  # GET /doc_boletas/new
  def new
    @objeto = DocBoleta.new
  end

  # GET /doc_boletas/1/edit
  def edit
  end

  # POST /doc_boletas or /doc_boletas.json
  def create
    @objeto = DocBoleta.new(doc_boleta_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto.doc_honorario, notice: "Doc boleta was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_boletas/1 or /doc_boletas/1.json
  def update
    respond_to do |format|
      if @objeto.update(doc_boleta_params)
        format.html { redirect_to @objeto.doc_honorario, notice: "Doc boleta was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_boletas/1 or /doc_boletas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @objeto.doc_honorario, status: :see_other, notice: "Doc boleta was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_boleta
      @objeto = DocBoleta.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doc_boleta_params
      params.expect(doc_boleta: [ :ownr_type, :ownr_id, :detalle ])
    end
end
