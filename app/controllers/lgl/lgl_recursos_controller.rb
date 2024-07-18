class Lgl::LglRecursosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_lgl_recurso, only: %i[ show edit update destroy ]

  # GET /lgl_recursos or /lgl_recursos.json
  def index
    @coleccion = LglRecurso.all
  end

  # GET /lgl_recursos/1 or /lgl_recursos/1.json
  def show
  end

  # GET /lgl_recursos/new
  def new
    @objeto = LglRecurso.new
  end

  # GET /lgl_recursos/1/edit
  def edit
  end

  # POST /lgl_recursos or /lgl_recursos.json
  def create
    @objeto = LglRecurso.new(lgl_recurso_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to lgl_recurso_url(@objeto), notice: "Lgl recurso was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_recursos/1 or /lgl_recursos/1.json
  def update
    respond_to do |format|
      if @objeto.update(lgl_recurso_params)
        format.html { redirect_to lgl_recurso_url(@objeto), notice: "Lgl recurso was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgl_recursos/1 or /lgl_recursos/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to lgl_recursos_url, notice: "Lgl recurso was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_recurso
      @objeto = LglRecurso.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lgl_recurso_params
      params.require(:lgl_recurso).permit(:lgl_recurso, :tipo)
    end
end
