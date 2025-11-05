class Lgl::LglLeyesController < ApplicationController
  before_action :set_lgl_ley, only: %i[ show edit update destroy ]

  # GET /lgl_leyes or /lgl_leyes.json
  def index
    @coleccion = LglLey.all
  end

  # GET /lgl_leyes/1 or /lgl_leyes/1.json
  def show
  end

  # GET /lgl_leyes/new
  def new
    @objeto = LglLey.new(lgl_repositorio_id: params[:oid])
  end

  # GET /lgl_leyes/1/edit
  def edit
  end

  # POST /lgl_leyes or /lgl_leyes.json
  def create
    @objeto = LglLey.new(lgl_ley_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to lgl_repositorios_path, notice: "Ley fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_leyes/1 or /lgl_leyes/1.json
  def update
    respond_to do |format|
      if @objeto.update(lgl_ley_params)
        format.html { redirect_to lgl_repositorios_path, notice: "Ley fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgl_leyes/1 or /lgl_leyes/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to lgl_repositorios_path, status: :see_other, notice: "Ley fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_ley
      @objeto = LglLey.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def lgl_ley_params
      params.expect(lgl_ley: [ :lgl_repositorio_id, :cdg, :nombre ])
    end
end
