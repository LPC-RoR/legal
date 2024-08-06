class Producto::ProClientesController < ApplicationController
  before_action :set_pro_cliente, only: %i[ show edit update destroy ]

  # GET /pro_clientes or /pro_clientes.json
  def index
    @pro_clientes = ProCliente.all
  end

  # GET /pro_clientes/1 or /pro_clientes/1.json
  def show
  end

  # GET /pro_clientes/new
  def new
    @pro_cliente = ProCliente.new
  end

  # GET /pro_clientes/1/edit
  def edit
  end

  # POST /pro_clientes or /pro_clientes.json
  def create
    @pro_cliente = ProCliente.new(pro_cliente_params)

    respond_to do |format|
      if @pro_cliente.save
        format.html { redirect_to pro_cliente_url(@pro_cliente), notice: "Pro cliente was successfully created." }
        format.json { render :show, status: :created, location: @pro_cliente }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pro_cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pro_clientes/1 or /pro_clientes/1.json
  def update
    respond_to do |format|
      if @pro_cliente.update(pro_cliente_params)
        format.html { redirect_to pro_cliente_url(@pro_cliente), notice: "Pro cliente was successfully updated." }
        format.json { render :show, status: :ok, location: @pro_cliente }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pro_cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pro_clientes/1 or /pro_clientes/1.json
  def destroy
    @pro_cliente.destroy!

    respond_to do |format|
      format.html { redirect_to pro_clientes_url, notice: "Pro cliente was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pro_cliente
      @pro_cliente = ProCliente.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pro_cliente_params
      params.require(:pro_cliente).permit(:cliente_id, :producto_id)
    end
end
