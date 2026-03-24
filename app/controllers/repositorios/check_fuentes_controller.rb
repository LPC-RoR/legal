class Repositorios::CheckFuentesController < ApplicationController
  before_action :set_check_fuente, only: %i[ show edit update destroy show_pdf ]

  # GET /check_fuentes or /check_fuentes.json
  def index
    @coleccion = CheckFuente.all
  end

  def show_pdf
    archivo = CheckFuente.find(params[:id])
    
    
    content = archivo.pdf.download
    
    # Si no es PDF, guardar para inspeccionar
    unless content.start_with?('%PDF')
      File.write(Rails.root.join('tmp', "error_show_pdf_#{archivo.id}.txt"), content)
      Rails.logger.error "ERROR: Contenido no es PDF, guardado en tmp/error_show_pdf_#{archivo.id}.txt"
    end
    
    send_data content,
              filename: archivo.pdf.filename.to_s,
              type: 'application/pdf',
              disposition: 'inline'
  end

  # GET /check_fuentes/1 or /check_fuentes/1.json
  def show
  end

  # GET /check_fuentes/new
  def new
    @objeto = CheckFuente.new(check_realizado_id: params[:oid], usuario_id: current_usuario.id)
  end

  # GET /check_fuentes/1/edit
  def edit
  end

  # POST /check_fuentes or /check_fuentes.json
  def create
    @objeto = CheckFuente.new(check_fuente_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to orgn_path, notice: "Fuente fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /check_fuentes/1 or /check_fuentes/1.json
  def update
    respond_to do |format|
      if @objeto.update(check_fuente_params)
        format.html { redirect_to orgn_path, notice: "Fuente fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_fuentes/1 or /check_fuentes/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to orgn_path, status: :see_other, notice: "Fuente fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_fuente
      @objeto = CheckFuente.find(params.expect(:id))
    end

    def orgn_path
      "/krn_denuncias/#{@objeto.check_realizado.ownr.dnnc.id}_1"
    end

    # Only allow a list of trusted parameters through.
    def check_fuente_params
      params.expect(check_fuente: [ :check_realizado_id, :usuario_id, :fecha, :fuente, :pdf ])
    end
end
