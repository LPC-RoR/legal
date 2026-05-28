class DocPagosController < ApplicationController
  before_action :set_doc_pago, only: %i[ show edit update destroy ]

  # GET /doc_pagos or /doc_pagos.json
  def index
    @doc_pagos = DocPago.all
  end

  # GET /doc_pagos/1 or /doc_pagos/1.json
  def show
  end

  # GET /doc_pagos/new
  def new
    @doc_pago = DocPago.new
  end

  # GET /doc_pagos/1/edit
  def edit
  end

  # POST /doc_pagos or /doc_pagos.json
  def create
    @doc_pago = DocPago.new(doc_pago_params)

    respond_to do |format|
      if @doc_pago.save
        format.html { redirect_to @doc_pago, notice: "Doc pago was successfully created." }
        format.json { render :show, status: :created, location: @doc_pago }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @doc_pago.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_pagos/1 or /doc_pagos/1.json
  def update
    respond_to do |format|
      if @doc_pago.update(doc_pago_params)
        format.html { redirect_to @doc_pago, notice: "Doc pago was successfully updated." }
        format.json { render :show, status: :ok, location: @doc_pago }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @doc_pago.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_pagos/1 or /doc_pagos/1.json
  def destroy
    @doc_pago.destroy!

    respond_to do |format|
      format.html { redirect_to doc_pagos_path, status: :see_other, notice: "Doc pago was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_pago
      @doc_pago = DocPago.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doc_pago_params
      params.expect(doc_pago: [ :doc_transaccion_id, :ownr_type, :ownr_id, :folio_referencia, :monto ])
    end
end
