class Lgl::LglParrafosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_lgl_parrafo, only: %i[ show edit update destroy arriba abajo swtch padd cnct_up prnt ]
  after_action :reordenar, only: %i[ destroy update cnct_up]
#  after_action :chk_tgs, only: :update

  include Orden

  # GET /lgl_parrafos or /lgl_parrafos.json
  def index
    @coleccion = LglParrafo.all
  end

  # GET /lgl_parrafos/1 or /lgl_parrafos/1.json
  def show
    set_tabla('lgl_datos', @objeto.lgl_datos.order(:orden), false)
  end

  # GET /lgl_parrafos/new
  def new
    doc = LglDocumento.find(params[:oid])
    ordn = doc.lgl_parrafos.count + 1
    @objeto = LglParrafo.new(lgl_documento_id: params[:oid], orden: ordn)
  end

  # GET /lgl_parrafos/1/edit
  def edit
  end

  # POST /lgl_parrafos or /lgl_parrafos.json
  def create
    @objeto = LglParrafo.new(lgl_parrafo_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Párrafo fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_parrafos/1 or /lgl_parrafos/1.json
  def update
    respond_to do |format|
      if @objeto.update(lgl_parrafo_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Párrafo fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def padd
    if params[:d] == 'r'
      @objeto.pdd_lft = @objeto.pdd_lft.blank? ? 1 : @objeto.pdd_lft + 1
    end
    @objeto.pdd_lft -= 1 if params[:d] == 'l'
    @objeto.save

    get_rdrccn
    redirect_to @rdrccn
  end

  # PARENT
  def prnt

    padre = @objeto.parent
    abuelo = @objeto.parent.blank? ? nil : @objeto.parent.parent

    documento = @objeto.lgl_documento

    if params[:d] == 'u'
      anterior = documento.lgl_parrafos.find_by(orden: @objeto.orden - 1)
      padre_anterior = anterior.parent
      if padre_anterior.blank?
        # Lo hacemos hijo de anterior, a menos que ya se encuentre ahí
        anterior.children << @objeto unless @objeto.parent == anterior
      else
        if padre_anterior == padre
          padre.children.delete(@objeto)
          anterior.children << @objeto
        else
          padre.children.delete(@objeto) unless padre.blank?
          padre_anterior.children << @objeto
        end
      end
    else
      padre.children.delete(@objeto) unless padre.blank?
      abuelo.children << @objeto unless abuelo.blank?
    end

    get_rdrccn
    redirect_to @rdrccn
  end

  def cnct_up
    unless @objeto.blank?    
      documento = @objeto.lgl_documento
      anterior = documento.lgl_parrafos.find_by(orden: @objeto.orden - 1)
      anterior.lgl_parrafo += @objeto.lgl_parrafo
      anterior.save

      @objeto.delete
    end

    get_rdrccn
    redirect_to @rdrccn
  end

  # DELETE /lgl_parrafos/1 or /lgl_parrafos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Párrafo fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private

    def chk_tgs
      v = @objeto.lgl_parrafo.split('#|')
      if v.length > 1
        frst = v[0]
        rst = v[1, v.length - 1]

        @objeto.lgl_parrafo = frst
        @objeto.save
        rst.each_with_index do |prt, indx|
          prr = indx == rst.length - 1 ? prt : "#{prt}\n"
          LglParrafo.create(lgl_documento_id: @objeto.lgl_documento_id, orden: @objeto.orden, lgl_parrafo: prr)
        end
      end
      reordenar
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_parrafo
      @objeto = LglParrafo.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = "/lgl_documentos/#{@objeto.lgl_documento_id}#lgl_parrafos_#{@objeto.orden == 1 ? 1 : @objeto.orden - 1}"
    end

    # Only allow a list of trusted parameters through.
    def lgl_parrafo_params
      params.require(:lgl_parrafo).permit(:lgl_documento_id, :orden, :codigo, :lgl_parrafo, :tipo, :definicion, :accion, :resumen, :ocultar)
    end
end
