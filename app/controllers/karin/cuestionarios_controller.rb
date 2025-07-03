class Karin::CuestionariosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_cuestionario, only: %i[ show edit update destroy ]

  # GET /cuestionarios or /cuestionarios.json
  def index
    @coleccion = Cuestionario.all
  end

  # GET /cuestionarios/1 or /cuestionarios/1.json
  def show
    set_tabla('preguntas', @objeto.preguntas.order(:orden), false)
  end

  # GET /cuestionarios/new
  def new
    pauta = Pauta.find(params[:pid])
    orden = pauta.cuestionarios.count + 1
    @objeto = Cuestionario.new(pauta_id: pauta.id, orden: orden)
  end

  # GET /cuestionarios/1/edit
  def edit
  end

  # POST /cuestionarios or /cuestionarios.json
  def create
    @objeto = Cuestionario.new(cuestionario_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Cuestionario fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cuestionarios/1 or /cuestionarios/1.json
  def update
    respond_to do |format|
      if @objeto.update(cuestionario_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Cuestionario fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cuestionarios/1 or /cuestionarios/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Cuestionario fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cuestionario
      @objeto = Cuestionario.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.pauta
    end

    # Only allow a list of trusted parameters through.
    def cuestionario_params
      params.require(:cuestionario).permit(:orden, :pauta_id, :cuestionario, :referencia)
    end
end
