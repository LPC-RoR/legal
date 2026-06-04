class Docs::DocCierresController < ApplicationController
  before_action :set_doc_cierre, only: %i[ show edit update destroy ]

  layout 'addt'

  # GET /doc_cierres or /doc_cierres.json
  def index
    @clccn = DocCierre.all
  end

  # GET /doc_cierres/1 or /doc_cierres/1.json
  def show
    @trnsccns = DocTransaccion.entre_fechas(@objeto.fecha_inicio, @objeto.fecha_termino)

    @cbrnz    = @trnsccns.where(relacionable_type: 'Cliente')
    @prvdrs   = @trnsccns.where(relacionable_type: 'Proveedor')
    @scs      = @trnsccns.where(relacionable_type: 'Trabajador').where(clasificacion: 'Socio/a')
    @trbjdrs  = @trnsccns.where(relacionable_type: 'Trabajador').where.not(clasificacion: 'Socio/a')
    @emtds    = DocEmitido.entre_fechas(@objeto.fecha_inicio, @objeto.fecha_termino)
    @rcbds    = DocRecibido.entre_fechas(@objeto.fecha_inicio, @objeto.fecha_termino)

    @fnncr    = @trnsccns.where(clasificacion: 'Financiero')
    @untrs    = @trnsccns.where(clasificacion: 'Pago TC', 'Imposiciones', 'IVA', 'Devolución impuestos')

    @ln_crdt  = @trnsccns.where(clasificacion: ['Pago LC', 'Abono a LC'])

    @pndnts   = @trnsccns.where(clasificacion: 'Pendiente')
  end

  # GET /doc_cierres/new
  def new
    @objeto = DocCierre.new
  end

  # GET /doc_cierres/1/edit
  def edit
  end

  # POST /doc_cierres or /doc_cierres.json
  def create
    @objeto = DocCierre.new(doc_cierre_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to doc_cierres_path, notice: "Doc cierre was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_cierres/1 or /doc_cierres/1.json
  def update
    respond_to do |format|
      if @objeto.update(doc_cierre_params)
        format.html { redirect_to doc_cierres_path, notice: "Doc cierre was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_cierres/1 or /doc_cierres/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to doc_cierres_path, status: :see_other, notice: "Doc cierre was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_cierre
      @objeto = DocCierre.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doc_cierre_params
      params.expect(doc_cierre: [ :fecha_inicio, :fecha_termino, :encabezado, :saldo_inicial, :saldo_final ])
    end
end
