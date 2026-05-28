class Docs::DocBancosController < ApplicationController
  before_action :set_doc_banco, only: %i[ show edit update destroy ]

  layout 'addt'

  # GET /doc_bancos or /doc_bancos.json
  def index
    @doc_bancos = DocBanco.all
  end

  # GET /doc_bancos/1 or /doc_bancos/1.json
  def show
  end

  # GET /doc_bancos/new
  def new
    @doc_banco = DocBanco.new
  end

  # GET /doc_bancos/1/edit
  def edit
  end

  # POST /doc_bancos or /doc_bancos.json
  def create
    @doc_banco = DocBanco.new(doc_banco_params)

    respond_to do |format|
      if @doc_banco.save
        format.html { redirect_to @doc_banco, notice: "Doc banco was successfully created." }
        format.json { render :show, status: :created, location: @doc_banco }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @doc_banco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_bancos/1 or /doc_bancos/1.json
  def update
    respond_to do |format|
      if @doc_banco.update(doc_banco_params)
        format.html { redirect_to @doc_banco, notice: "Doc banco was successfully updated." }
        format.json { render :show, status: :ok, location: @doc_banco }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @doc_banco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_bancos/1 or /doc_bancos/1.json
  def destroy
    @doc_banco.destroy!

    respond_to do |format|
      format.html { redirect_to doc_bancos_path, status: :see_other, notice: "Doc banco was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_banco
      @doc_banco = DocBanco.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doc_banco_params
      params.expect(doc_banco: [ :nombre, :rut ])
    end
end
