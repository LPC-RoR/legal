class Karin::RespuestasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_respuesta, only: %i[ show edit update destroy ]

  # GET /respuestas or /respuestas.json
  def index
    @coleccion = Respuesta.all
  end

  # GET /respuestas/1 or /respuestas/1.json
  def show
  end

  # GET /respuestas/new
  def new
    @objeto = Respuesta.new
  end

  def nueva
    pregunta = Pregunta.find(params[:sg])
    sesion = KSesion.find(params[:sid])
    f_prms = params[:sg_respuesta]
    unless pregunta.blank? or sesion.blank?
      sesion.respuestas.create(pregunta_id: pregunta.id, respuesta: f_prms[:respuesta], propuesta: f_prms[:propuesta])
    end

    redirect_to "/publicos/encuesta"
  end

  # GET /respuestas/1/edit
  def edit
  end

  # POST /respuestas or /respuestas.json
  def create
    @objeto = Respuesta.new(respuesta_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to respuesta_url(@objeto), notice: "Respuesta was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /respuestas/1 or /respuestas/1.json
  def update
    respond_to do |format|
      if @objeto.update(respuesta_params)
        format.html { redirect_to respuesta_url(@objeto), notice: "Respuesta was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /respuestas/1 or /respuestas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to respuestas_url, notice: "Respuesta was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_respuesta
      @objeto = Respuesta.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def respuesta_params
      params.require(:respuesta).permit(:campania_id, :sesion_id, :respuesta, :propuesta)
    end
end
