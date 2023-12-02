class ControlDocumentosController < ApplicationController
  before_action :set_control_documento, only: %i[ show edit update destroy ]

  # GET /control_documentos or /control_documentos.json
  def index
    @control_documentos = ControlDocumento.all
  end

  # GET /control_documentos/1 or /control_documentos/1.json
  def show
  end

  # GET /control_documentos/new
  def new
    @control_documento = ControlDocumento.new
  end

  # GET /control_documentos/1/edit
  def edit
  end

  # POST /control_documentos or /control_documentos.json
  def create
    @control_documento = ControlDocumento.new(control_documento_params)

    respond_to do |format|
      if @control_documento.save
        format.html { redirect_to @control_documento, notice: "Control documento was successfully created." }
        format.json { render :show, status: :created, location: @control_documento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @control_documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /control_documentos/1 or /control_documentos/1.json
  def update
    respond_to do |format|
      if @control_documento.update(control_documento_params)
        format.html { redirect_to @control_documento, notice: "Control documento was successfully updated." }
        format.json { render :show, status: :ok, location: @control_documento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @control_documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /control_documentos/1 or /control_documentos/1.json
  def destroy
    @control_documento.destroy
    respond_to do |format|
      format.html { redirect_to control_documentos_url, notice: "Control documento was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_control_documento
      @control_documento = ControlDocumento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def control_documento_params
      params.require(:control_documento).permit(:nombre, :descripcion, :tipo, :control, :owner_class, :owner_id)
    end
end
