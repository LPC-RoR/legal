class Modelos::MConceptosController < ApplicationController
  before_action :set_m_concepto, only: %i[ show edit update destroy arriba abajo]
  after_action :reordenar, only: :destroy

  # GET /m_conceptos or /m_conceptos.json
  def index
    @coleccion = MConcepto.all
  end

  # GET /m_conceptos/1 or /m_conceptos/1.json
  def show
  end

  # GET /m_conceptos/new
  def new
    modelo = MModelo.find(params[:objeto_id])
    @objeto = MConcepto.new(m_modelo_id: params[:objeto_id], orden: modelo.m_conceptos.count + 1)
  end

  # GET /m_conceptos/1/edit
  def edit
  end

  # POST /m_conceptos or /m_conceptos.json
  def create
    @objeto = MConcepto.new(m_concepto_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Concepto fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_conceptos/1 or /m_conceptos/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_concepto_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Concepto fue exitósamente actualizado." }
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

  # DELETE /m_conceptos/1 or /m_conceptos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Concepto fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_concepto
      @objeto = MConcepto.find(params[:id])
    end

    def set_redireccion
      @redireccion = m_modelos_path
    end

    # Only allow a list of trusted parameters through.
    def m_concepto_params
      params.require(:m_concepto).permit(:m_concepto, :m_modelo_id, :orden)
    end
end
