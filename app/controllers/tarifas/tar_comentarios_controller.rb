class Tarifas::TarComentariosController < ApplicationController
  before_action :set_tar_comentario, only: %i[ show edit update destroy ]

  # GET /tar_comentarios or /tar_comentarios.json
  def index
  end

  # GET /tar_comentarios/1 or /tar_comentarios/1.json
  def show
  end

  # GET /tar_comentarios/new
  def new
    @objeto = TarComentario.new(tar_pago_id: params[:tar_pago_id])
  end

  # GET /tar_comentarios/1/edit
  def edit
  end

  # POST /tar_comentarios or /tar_comentarios.json
  def create
    @objeto = TarComentario.new(tar_comentario_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar comentario was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_comentarios/1 or /tar_comentarios/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_comentario_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar comentario was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_comentarios/1 or /tar_comentarios/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tar comentario was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_comentario
      @objeto = TarComentario.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.tar_pago
    end

    # Only allow a list of trusted parameters through.
    def tar_comentario_params
      params.require(:tar_comentario).permit(:tar_pago_id, :orden, :tipo, :formula, :comentario, :opcional, :despliegue, :moneda)
    end
end
