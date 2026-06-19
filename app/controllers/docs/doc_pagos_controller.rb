class Docs::DocPagosController < ApplicationController
  before_action :set_doc_pago, only: %i[ show edit update destroy ]

  # GET /doc_pagos or /doc_pagos.json
  def index
    @clccn = DocPago.all
  end

  # GET /doc_pagos/1 or /doc_pagos/1.json
  def show
  end

  # GET /doc_pagos/new
  def new
    @objeto = DocPago.new(doc_transaccion_id: params[:oid])
  end

  # GET /doc_pagos/1/edit
  def edit
  end

  # POST /doc_pagos or /doc_pagos.json
  def create
    @objeto = DocPago.new(doc_pago_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto.doc_transaccion.relacionable, notice: "Asignación de transacción exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_pagos/1 or /doc_pagos/1.json
  def update
    respond_to do |format|
      if @objeto.update(doc_pago_params)
        format.html { redirect_to @objeto.doc_transaccion.relacionable, notice: "Asignación de transacción exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_pagos/1 or /doc_pagos/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @objeto.doc_transaccion.relacionable, status: :see_other, notice: "Asignación de transacción exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_pago
      @objeto = DocPago.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doc_pago_params
      params.expect(doc_pago: [ :doc_transaccion_id, :ownr_type, :ownr_id, :folio_referencia, :monto ])
    end
end
