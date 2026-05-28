class Docs::DocRecibidosController < ApplicationController
  before_action :set_doc_recibido, only: %i[ show edit update destroy ]

  # GET /doc_recibidos or /doc_recibidos.json
  def index
    @clccn = DocRecibido.all
  end

  # GET /doc_recibidos/1 or /doc_recibidos/1.json
  def show
  end

  # GET /doc_recibidos/new
  def new
    @objeto = DocRecibido.new
  end

  # GET /doc_recibidos/1/edit
  def edit
  end

  # POST /doc_recibidos or /doc_recibidos.json
  def create
    @objeto = DocRecibido.new(doc_recibido_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Doc recibido was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_recibidos/1 or /doc_recibidos/1.json
  def update
    respond_to do |format|
      if @objeto.update(doc_recibido_params)
        format.html { redirect_to @objeto, notice: "Doc recibido was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_recibidos/1 or /doc_recibidos/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to doc_recibidos_path, status: :see_other, notice: "Doc recibido was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_recibido
      @objeto = DocRecibido.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doc_recibido_params
      params.expect(doc_recibido: [ :rut_emisor ])
    end
end
