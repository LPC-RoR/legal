class ProveedoresController < ApplicationController
  before_action :set_proveedor, only: %i[ show edit update destroy ]

  layout 'addt'

  # GET /proveedores or /proveedores.json
  def index
    @clccn = Proveedor.all
  end

  # GET /proveedores/1 or /proveedores/1.json
  def show
    @trnsccns       = @objeto.doc_transacciones.order(fecha: :desc)
    @doc_recibidos  = @objeto.doc_recibidos.order(fecha_emision: :desc)
  end

  # GET /proveedores/new
  def new
    @objeto = Proveedor.new
  end

  # GET /proveedores/1/edit
  def edit
  end

  # POST /proveedores or /proveedores.json
  def create
    @objeto = Proveedor.new(proveedor_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Proveedor was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proveedores/1 or /proveedores/1.json
  def update
    respond_to do |format|
      if @objeto.update(proveedor_params)
        format.html { redirect_to @objeto, notice: "Proveedor was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proveedores/1 or /proveedores/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to proveedores_path, status: :see_other, notice: "Proveedor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proveedor
      @objeto = Proveedor.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def proveedor_params
      params.expect(proveedor: [ :razon_social, :rut ])
    end
end
