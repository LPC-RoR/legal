class Modelos::MFormatosController < ApplicationController
  before_action :set_m_formato, only: %i[ show edit update destroy ]

  # GET /m_formatos or /m_formatos.json
  def index
    @coleccion = MFormato.all
  end

  # GET /m_formatos/1 or /m_formatos/1.json
  def show
    init_tabla('m_datos', @objeto.m_datos.order(:orden), false)
    add_tabla('m_elementos', @objeto.m_elementos.order(:orden), false)
  end

  # GET /m_formatos/new
  def new
#    owner = MBanco.find(params[:m_banco_id])
    @objeto = MFormato.new(m_banco_id: params[:m_banco_id])
  end

  # GET /m_formatos/1/edit
  def edit
  end

  # POST /m_formatos or /m_formatos.json
  def create
    @objeto = MFormato.new(m_formato_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Formato fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_formatos/1 or /m_formatos/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_formato_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Formato fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /m_formatos/1 or /m_formatos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Formato fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_formato
      @objeto = MFormato.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.m_banco
    end

    # Only allow a list of trusted parameters through.
    def m_formato_params
      params.require(:m_formato).permit(:m_formato, :m_banco_id, :inicio, :termino)
    end
end
