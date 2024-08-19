class Tarifas::TarComentariosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tar_comentario, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /tar_comentarios or /tar_comentarios.json
  def index
  end

  # GET /tar_comentarios/1 or /tar_comentarios/1.json
  def show
  end

  # GET /tar_comentarios/new
  def new
    ownr = params[:oclss].constantize.find(params[:oid])
    @objeto = TarComentario.new(tar_pago_id: ownr.id, orden: ownr.tar_comentarios.count + 1)
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
        format.html { redirect_to @redireccion, notice: "Comentario fue exitósamente creado." }
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
        format.html { redirect_to @redireccion, notice: "Comentario fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def arriba
    owner = @objeto.owner
    anterior = @objeto.anterior
    @objeto.orden -= 1
    @objeto.save
    anterior.orden += 1
    anterior.save

    redirect_to @objeto.redireccion
  end

  def abajo
    owner = @objeto.owner
    siguiente = @objeto.siguiente
    @objeto.orden += 1
    @objeto.save
    siguiente.orden -= 1
    siguiente.save

    redirect_to @objeto.redireccion
  end

  def reordenar
    @objeto.list.each_with_index do |val, index|
      unless val.orden == index + 1
        val.orden = index + 1
        val.save
      end
    end
  end

  # DELETE /tar_comentarios/1 or /tar_comentarios/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Comentario fue exitósamente eliminado." }
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
