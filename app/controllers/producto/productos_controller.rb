class Producto::ProductosController < ApplicationController
  before_action :authenticate_usuario!, except: %i[partial]
  before_action :scrty_on, except: %i[partial]
  before_action :set_producto, only: %i[ show edit update destroy agrega_producto elimina_producto ]

  ALLOWED = {
    "formales"       => "producto/productos/prtls/formales",
    "legales"        => "producto/productos/prtls/legales",
    "externas"       => "producto/productos/prtls/externas",
    "implementacion" => "producto/productos/prtls/implementacion",
    "capacitacion"   => "producto/productos/prtls/capacitacion",
    "asesoria"       => "producto/productos/prtls/asesoria"
  }.freeze

  def partial
    key = params[:key].to_s
    partial_path = ALLOWED[key]
    return head :not_found unless partial_path

    render partial: partial_path, formats: [:html], layout: false, status: :ok
  end


  # GET /productos or /productos.json
  def index
    set_tabla('productos', Producto.lst, false)
  end

  # GET /productos/1 or /productos/1.json
  def show
  end

  # GET /productos/new
  def new
    @objeto = Producto.new
  end

  # GET /productos/1/edit
  def edit
  end

  # POST /productos or /productos.json
  def create
    @objeto = Producto.new(producto_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Producto fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /productos/1 or /productos/1.json
  def update
    respond_to do |format|
      if @objeto.update(producto_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Producto fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def agrega_producto
    cliente = Cliente.find(params[:cid])
    cliente.productos << @objeto

    redirect_to "/clientes/#{cliente.id}?html_options[menu]=#{CGI.escape('Configuración')}"
  end

  def elimina_producto
    cliente = Cliente.find(params[:cid])
    cliente.productos.delete(@objeto)

    redirect_to "/clientes/#{cliente.id}?html_options[menu]=#{CGI.escape('Configuración')}"
  end

  # DELETE /productos/1 or /productos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Producto fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_producto
      @objeto = Producto.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = productos_path
    end

    # Only allow a list of trusted parameters through.
    def producto_params
      params.require(:producto).permit(:producto, :codigo, :tipo, :procedimiento_id, :formato, :prepago, :capacidad, :moneda, :precio)
    end
end
