class Repositorios::CheckRealizadosController < ApplicationController
  before_action :set_check_realizado, only: %i[ show show_pdf edit update destroy excluir ]

  include ActCheck

  # GET /check_realizados or /check_realizados.json
  def index
    @coleccion = CheckRealizado.all
  end

  # GET /check_realizados/1 or /check_realizados/1.json
  def show
  end

  # GET /act_archivos/1 or /act_archivos/1.json
  def show_pdf
    
    content = @objeto.pdf.download
    
    # Si no es PDF, guardar para inspeccionar
    unless content.start_with?('%PDF')
      File.write(Rails.root.join('tmp', "error_show_pdf_#{@objeto.id}.txt"), content)
      Rails.logger.error "ERROR: Contenido no es PDF, guardado en tmp/error_show_pdf_#{@objeto.id}.txt"
    end
    
    send_data content,
              filename: @objeto.pdf.filename.to_s,
              type: 'application/pdf',
              disposition: 'inline'
  end

  # GET /check_realizados/new
  def new
    ownr = params[:oclss].constantize.find(params[:oid])
    @objeto = ownr.check_realizados.new(usuario_id: current_usuario.id, chequed_at: Time.zone.now, mdl: 'act', cdg: params[:cdg])
  end

  # GET /check_realizados/1/edit
  def edit
  end

  # POST /check_realizados or /check_realizados.json
  def create
    @objeto = CheckRealizado.new(check_realizado_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to act_archivo_rdrccn(@objeto), notice: "Chequeo fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /check_realizados/1 or /check_realizados/1.json
  def update
    respond_to do |format|
      if @objeto.update(check_realizado_params)
        format.html { redirect_to act_archivo_rdrccn(@objeto), notice: "Chequeo fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_realizados/1 or /check_realizados/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to act_archivo_rdrccn(@objeto), status: :see_other, notice: "Eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_realizado
      @objeto = CheckRealizado.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def check_realizado_params
      params.expect(check_realizado: [ :ownr_type, :ownr_id, :usuario_id, :mdl, :cdg, :rlzd, :chequed_at, :fecha_envio, :fuente, :pdf ])
    end
end
