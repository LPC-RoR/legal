class Hm::HPreguntasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_h_pregunta, only: %i[ show edit update destroy ]

  # GET /h_preguntas or /h_preguntas.json
  def index
    set_tabla('h_preguntas', HPregunta.all, false)
  end

  # GET /h_preguntas/1 or /h_preguntas/1.json
  def show
  end

  # GET /h_preguntas/new
  def new
    @objeto = HPregunta.new
  end

  # GET /h_preguntas/1/edit
  def edit
  end

  # POST /h_preguntas or /h_preguntas.json
  def create
    @objeto = HPregunta.new(h_pregunta_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Pregunta fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /h_preguntas/1 or /h_preguntas/1.json
  def update
    respond_to do |format|
      if @objeto.update(h_pregunta_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Pregunta fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /h_preguntas/1 or /h_preguntas/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Pregunta fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_h_pregunta
      @objeto = HPregunta.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = h_preguntas_path
    end

    # Only allow a list of trusted parameters through.
    def h_pregunta_params
      params.require(:h_pregunta).permit(:codigo, :h_pregunta, :respuesta, :lnk_txt, :lnk)
    end
end
