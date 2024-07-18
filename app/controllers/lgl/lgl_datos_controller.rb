class Lgl::LglDatosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_lgl_dato, only: %i[ show edit update destroy ]

  # GET /lgl_datos or /lgl_datos.json
  def index
    @coleccion = LglDato.all
  end

  # GET /lgl_datos/1 or /lgl_datos/1.json
  def show
  end

  # GET /lgl_datos/new
  def new
    parrafo = LglParrafo.find(params[:oid])
    orden = parrafo.lgl_datos.count + 1
    @objeto = LglDato.new(lgl_parrafo_id: parrafo.id, orden: orden)
  end

  # GET /lgl_datos/1/edit
  def edit
  end

  # POST /lgl_datos or /lgl_datos.json
  def create
    @objeto = LglDato.new(lgl_dato_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Dato legal fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_datos/1 or /lgl_datos/1.json
  def update
    respond_to do |format|
      if @objeto.update(lgl_dato_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Dato legal fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgl_datos/1 or /lgl_datos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Dato legal fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_dato
      @objeto = LglDato.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.lgl_parrafo
    end

    # Only allow a list of trusted parameters through.
    def lgl_dato_params
      params.require(:lgl_dato).permit(:lgl_parrafo_id, :orden, :lgl_dato, :cita)
    end
end
