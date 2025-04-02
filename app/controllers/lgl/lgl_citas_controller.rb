class Lgl::LglCitasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_lgl_cita, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: %i[ destroy update]

  include Orden
  
  # GET /lgl_citas or /lgl_citas.json
  def index
    @coleccion = LglCita.all
  end

  # GET /lgl_citas/1 or /lgl_citas/1.json
  def show
  end

  # GET /lgl_citas/new
  def new
    parr = LglParrafo.find(params[:oid])
    ordn = parr.lgl_citas.count + 1
    @objeto = LglCita.new(lgl_parrafo_id: params[:oid], orden: ordn)
  end

  # GET /lgl_citas/1/edit
  def edit
  end

  # POST /lgl_citas or /lgl_citas.json
  def create
    @objeto = LglCita.new(lgl_cita_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Cita fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_citas/1 or /lgl_citas/1.json
  def update
    respond_to do |format|
      if @objeto.update(lgl_cita_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Cita fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgl_citas/1 or /lgl_citas/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, status: :see_other, notice: "Cita fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_cita
      @objeto = LglCita.find(params.expect(:id))
    end

    def get_rdrccn
      @rdrccn = @objeto.lgl_parrafo
    end

    # Only allow a list of trusted parameters through.
    def lgl_cita_params
      params.expect(lgl_cita: [ :lgl_parrafo_id, :orden, :codigo, :lgl_cita, :referencia ])
    end
end
