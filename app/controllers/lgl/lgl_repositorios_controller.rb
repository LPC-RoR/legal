class Lgl::LglRepositoriosController < ApplicationController
  before_action :set_lgl_repositorio, only: %i[ show edit update destroy ]

  # GET /lgl_repositorios or /lgl_repositorios.json
  def index
    @clccn = LglRepositorio.all.order(:nombre)
  end

  # GET /lgl_repositorios/1 or /lgl_repositorios/1.json
  def show
  end

  # GET /lgl_repositorios/new
  def new
    @objeto = LglRepositorio.new
  end

  # GET /lgl_repositorios/1/edit
  def edit
  end

  # POST /lgl_repositorios or /lgl_repositorios.json
  def create
    @objeto = LglRepositorio.new(lgl_repositorio_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to lgl_repositorios_path, notice: "Repositorio fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_repositorios/1 or /lgl_repositorios/1.json
  def update
    respond_to do |format|
      if @objeto.update(lgl_repositorio_params)
        format.html { redirect_to lgl_repositorios_path, notice: "Repositorio fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgl_repositorios/1 or /lgl_repositorios/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to lgl_repositorios_path, status: :see_other, notice: "Repositorio fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_repositorio
      @objeto = LglRepositorio.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def lgl_repositorio_params
      params.expect(lgl_repositorio: [ :cdg, :nombre ])
    end
end
