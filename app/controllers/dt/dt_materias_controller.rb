class Dt::DtMateriasController < ApplicationController
  before_action :set_dt_materia, only: %i[ show edit update destroy ]

  # GET /dt_materias or /dt_materias.json
  def index
    set_tabla('dt_materias', DtMateria.all.order(:capitulo), false)
    set_tabla('dt_tabla_multas', DtTablaMulta.all.order(:dt_tabla_multa), false)
  end

  # GET /dt_materias/1 or /dt_materias/1.json
  def show
    set_tabla('dt_infracciones', @objeto.dt_infracciones.order(:codigo), false)
  end

  # GET /dt_materias/new
  def new
    @objeto = DtMateria.new
  end

  # GET /dt_materias/1/edit
  def edit
  end

  # POST /dt_materias or /dt_materias.json
  def create
    @objeto = DtMateria.new(dt_materia_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Materia fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dt_materias/1 or /dt_materias/1.json
  def update
    respond_to do |format|
      if @objeto.update(dt_materia_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Materia fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dt_materias/1 or /dt_materias/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Materia fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dt_materia
      @objeto = DtMateria.find(params[:id])
    end

    def set_redireccion
      @redireccion = dt_materias_path
    end

    # Only allow a list of trusted parameters through.
    def dt_materia_params
      params.require(:dt_materia).permit(:dt_materia, :capitulo)
    end
end
