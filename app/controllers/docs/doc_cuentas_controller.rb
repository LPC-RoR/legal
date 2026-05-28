class Docs::DocCuentasController < ApplicationController
  before_action :set_doc_cuenta, only: %i[ show edit update destroy ]

  layout 'addt'

  # GET /doc_cuentas or /doc_cuentas.json
  def index
    @doc_cuentas = DocCuenta.all
  end

  # GET /doc_cuentas/1 or /doc_cuentas/1.json
  def show
  end

  # GET /doc_cuentas/new
  def new
    @doc_cuenta = DocCuenta.new
  end

  # GET /doc_cuentas/1/edit
  def edit
  end

  # POST /doc_cuentas or /doc_cuentas.json
  def create
    @doc_cuenta = DocCuenta.new(doc_cuenta_params)

    respond_to do |format|
      if @doc_cuenta.save
        format.html { redirect_to @doc_cuenta, notice: "Doc cuenta was successfully created." }
        format.json { render :show, status: :created, location: @doc_cuenta }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @doc_cuenta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_cuentas/1 or /doc_cuentas/1.json
  def update
    respond_to do |format|
      if @doc_cuenta.update(doc_cuenta_params)
        format.html { redirect_to @doc_cuenta, notice: "Doc cuenta was successfully updated." }
        format.json { render :show, status: :ok, location: @doc_cuenta }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @doc_cuenta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_cuentas/1 or /doc_cuentas/1.json
  def destroy
    @doc_cuenta.destroy!

    respond_to do |format|
      format.html { redirect_to doc_cuentas_path, status: :see_other, notice: "Doc cuenta was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_cuenta
      @doc_cuenta = DocCuenta.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doc_cuenta_params
      params.expect(doc_cuenta: [ :sucursal ])
    end
end
