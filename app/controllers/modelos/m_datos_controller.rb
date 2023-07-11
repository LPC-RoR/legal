class Modelos::MDatosController < ApplicationController
  before_action :set_m_dato, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /m_datos or /m_datos.json
  def index
    @coleccion = MDato.all
  end

  # GET /m_datos/1 or /m_datos/1.json
  def show
  end

  # GET /m_datos/new
  def new
    formato = MFormato.find(params[:m_formato_id])
    @objeto = MDato.new(m_formato_id: params[:m_formato_id], orden: formato.m_datos.count + 1)
  end

  # GET /m_datos/1/edit
  def edit
  end

  # POST /m_datos or /m_datos.json
  def create
    @objeto = MDato.new(m_dato_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Dato fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_datos/1 or /m_datos/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_dato_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Dato fue exitósamente actualizado." }
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

  # DELETE /m_datos/1 or /m_datos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Dato fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_dato
      @objeto = MDato.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.m_formato
    end

    # Only allow a list of trusted parameters through.
    def m_dato_params
      params.require(:m_dato).permit(:m_dato, :tipo, :formula, :split_tag, :m_formato_id, :orden)
    end
end
