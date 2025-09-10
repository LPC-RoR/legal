class Pdf::PdfRegistrosController < ApplicationController
  before_action :set_pdf_registro, only: %i[ show edit update destroy ]

  # GET /pdf_registros or /pdf_registros.json
  def index
    @coleccion = PdfRegistro.all
  end

  # GET /pdf_registros/1 or /pdf_registros/1.json
  def show
  end

  # GET /pdf_registros/new
  def new
    @objeto = PdfRegistro.new
  end

  # GET /pdf_registros/1/edit
  def edit
  end

  # POST /pdf_registros or /pdf_registros.json
  def create
    @objeto = PdfRegistro.new(pdf_registro_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Pdf registro was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pdf_registros/1 or /pdf_registros/1.json
  def update
    respond_to do |format|
      if @objeto.update(pdf_registro_params)
        format.html { redirect_to @objeto, notice: "Pdf registro was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pdf_registros/1 or /pdf_registros/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, status: :see_other, notice: "Registro fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pdf_registro
      @objeto = PdfRegistro.find(params.expect(:id))
    end

    def get_rdrccn
      @rdrccn = @objeto.rdrccn
    end

    # Only allow a list of trusted parameters through.
    def pdf_registro_params
      params.expect(pdf_registro: [ :ownr_type, :ownr_id, :pdf_archivo_id, :cdg ])
    end
end
