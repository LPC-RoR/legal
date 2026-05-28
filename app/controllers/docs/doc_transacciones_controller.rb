class Docs::DocTransaccionesController < ApplicationController
  before_action :set_doc_transaccion, only: %i[ show edit update destroy ]

  layout 'addt'

  # GET /doc_transacciones or /doc_transacciones.json
  def index
    @clccn = DocTransaccion.all
  end

  # GET /doc_transacciones/1 or /doc_transacciones/1.json
  def show
  end

  # GET /doc_transacciones/new
  def new
    @objeto = DocTransaccion.new
  end

  # GET /doc_transacciones/1/edit
  def edit
  end

  # POST /doc_transacciones or /doc_transacciones.json
  def create
    @objeto = DocTransaccion.new(doc_transaccion_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Doc transaccion was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_transacciones/1 or /doc_transacciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(doc_transaccion_params)
        format.html { redirect_to @objeto, notice: "Doc transaccion was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def vincular
    @objeto = DocTransaccion.find(params[:id])
    
    if @objeto.descripcion_rut.blank?
      redirect_back fallback_location: root_path, alert: 'Esta transacción no tiene un RUT asociado para vincular.'
      return
    end

    @objeto.vincular!

    if @objeto.vinculada?
      redirect_back fallback_location: root_path, notice: "Transacción vinculada con #{@objeto.relacionable.class.name}: #{@objeto.relacionable.try(:nombre) || @transaccion.relacionable.rut}"
    else
      redirect_back fallback_location: root_path, alert: 'No se encontró Cliente, Proveedor ni Colaborador con el RUT de esta transacción.'
    end
  end

  # DELETE /doc_transacciones/1 or /doc_transacciones/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to doc_transacciones_path, status: :see_other, notice: "Doc transaccion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_transaccion
      @objeto = DocTransaccion.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doc_transaccion_params
      params.expect(doc_transaccion: [ :descripcion ])
    end
end
