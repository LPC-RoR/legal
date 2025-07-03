class Karin::PreguntasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_pregunta, only: %i[ show edit update destroy ]
  before_action :set_bck_rdrccn

  # GET /preguntas or /preguntas.json
  def index
    @coleccion = Pregunta.all
  end

  # GET /preguntas/1 or /preguntas/1.json
  def show
  end

  # GET /preguntas/new
  def new
    cuestionario = Cuestionario.find(params[:oid])
    orden = cuestionario.preguntas.count + 1
    @objeto = cuestionario.preguntas.new(orden: orden)
  end

  # GET /preguntas/1/edit
  def edit
  end

  # POST /preguntas or /preguntas.json
  def create
    @objeto = Pregunta.new(pregunta_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to params[:bck_rdrccn], notice: "Pregunta fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /preguntas/1 or /preguntas/1.json
  def update
    respond_to do |format|
      if @objeto.update(pregunta_params)
        format.html { redirect_to params[:bck_rdrccn], notice: "Pregunta fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /preguntas/1 or /preguntas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @bck_rdrccn, notice: "Pregunta fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pregunta
      @objeto = Pregunta.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pregunta_params
      params.require(:pregunta).permit(:orden, :pregunta, :tipo, :referencia, :cuestionario_id)
    end
end
