class Modelos::MItemsController < ApplicationController
  before_action :set_m_item, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /m_items or /m_items.json
  def index
    @coleccion = MItem.all
  end

  # GET /m_items/1 or /m_items/1.json
  def show
    periodo = MPeriodo.find(params[:oid])
    init_tabla('item-m_registros', @objeto.m_registros.where(m_periodo_id: params[:oid]).order(:orden), false)
    add_tabla('periodo-m_registros', periodo.m_registros.where(m_item_id: nil).order(:orden), false)
  end

  # GET /m_items/new
  def new
    owner = MConcepto.find(params[:oid])
    @objeto = MItem.new(m_concepto_id: params[:oid], orden: owner.m_items.count + 1)
  end

  # GET /m_items/1/edit
  def edit
  end

  # POST /m_items or /m_items.json
  def create
    @objeto = MItem.new(m_item_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Item fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_items/1 or /m_items/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_item_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Item fue exitósamente actualizado." }
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

  # DELETE /m_items/1 or /m_items/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Item fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_item
      @objeto = MItem.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/tablas?tb=#{tb_index('modelo')}"
    end

    # Only allow a list of trusted parameters through.
    def m_item_params
      params.require(:m_item).permit(:orden, :m_item, :m_concepto_id, :presupuesto)
    end
end
