class Lgl::LglPuntosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_lgl_punto, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: %i[ destroy ]

  # GET /lgl_puntos or /lgl_puntos.json
  def index
    @coleccion = LglPunto.all
  end

  # GET /lgl_puntos/1 or /lgl_puntos/1.json
  def show
  end

  # GET /lgl_puntos/new
  def new
    parrafo = LglParrafo.find(params[:oid])
    orden = parrafo.lgl_puntos.count + 1
    @objeto = LglPunto.new(lgl_parrafo_id: parrafo.id, orden: orden)
  end

  # GET /lgl_puntos/1/edit
  def edit
  end

  # POST /lgl_puntos or /lgl_puntos.json
  def create
    @objeto = LglPunto.new(lgl_punto_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Punto fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_puntos/1 or /lgl_puntos/1.json
  def update
    respond_to do |format|
      if @objeto.update(lgl_punto_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Punto fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgl_puntos/1 or /lgl_puntos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Punto fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_punto
      @objeto = LglPunto.find(params[:id])
    end

    def get_rdrccn
      parrafo = @objeto.lgl_parrafo
      documento = parrafo.lgl_documento
      @rdrccn = "/lgl_documentos/#{documento.id}#oid_#{parrafo.id}"
    end

    # Only allow a list of trusted parameters through.
    def lgl_punto_params
      params.require(:lgl_punto).permit(:orden, :lgl_parrafo_id, :lgl_punto, :cita)
    end
end
