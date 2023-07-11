class Modelos::MElementosController < ApplicationController
  before_action :set_m_elemento, only: %i[ show edit update destroy arriba abajo]
  after_action :reordenar, only: :destroy

  # GET /m_elementos or /m_elementos.json
  def index
    @coleccion = MElemento.all
  end

  # GET /m_elementos/1 or /m_elementos/1.json
  def show
  end

  # GET /m_elementos/new
  def new
    formato = MFormato.find(params[:m_formato_id])
    @objeto = MElemento.new(m_formato_id: params[:m_formato_id], orden: formato.m_elementos.count + 1)
  end

  # GET /m_elementos/1/edit
  def edit
  end

  # POST /m_elementos or /m_elementos.json
  def create
    @objeto = MElemento.new(m_elemento_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Elemento fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_elementos/1 or /m_elementos/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_elemento_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Elemento fue exitósamente actualizado." }
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

  # DELETE /m_elementos/1 or /m_elementos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Elemento fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_elemento
      @objeto = MElemento.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.m_formato
    end

    # Only allow a list of trusted parameters through.
    def m_elemento_params
      params.require(:m_elemento).permit(:orden, :m_elemento, :tipo, :m_formato_id, :registro, :columna)
    end
end
