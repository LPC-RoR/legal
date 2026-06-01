class Docs::DocNotasController < ApplicationController
  before_action :set_doc_nota, only: %i[ show edit update destroy ]

  # GET /doc_notas or /doc_notas.json
  def index
    @clccn = DocNota.all
  end

  # GET /doc_notas/1 or /doc_notas/1.json
  def show
  end

  # GET /doc_notas/new
  def new
    @objeto = DocNota.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  # GET /doc_notas/1/edit
  def edit
  end

  # POST /doc_notas or /doc_notas.json
  def create
    @objeto = DocNota.new(doc_nota_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to doc_cierres_path, notice: "Doc nota was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_notas/1 or /doc_notas/1.json
  def update
    respond_to do |format|
      if @objeto.update(doc_nota_params)
        format.html { redirect_to doc_cierres_path, notice: "Doc nota was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_notas/1 or /doc_notas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to doc_cierres_path, status: :see_other, notice: "Doc nota was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_nota
      @objeto = DocNota.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doc_nota_params
      params.expect(doc_nota: [ :ownr_type, :ownr_id, :nota ])
    end
end
