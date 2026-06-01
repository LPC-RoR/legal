class TrabajadoresController < ApplicationController
  before_action :set_trabajador, only: %i[ show edit update destroy ]

  layout 'addt'

  # GET /trabajadores or /trabajadores.json
  def index
    @clccn = Trabajador.all
  end

  # GET /trabajadores/1 or /trabajadores/1.json
  def show
  end

  # GET /trabajadores/new
  def new
    @objeto = Trabajador.new
  end

  # GET /trabajadores/1/edit
  def edit
  end

  # POST /trabajadores or /trabajadores.json
  def create
    @objeto = Trabajador.new(trabajador_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to trabajadores_path, notice: "Trabajador was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trabajadores/1 or /trabajadores/1.json
  def update
    respond_to do |format|
      if @objeto.update(trabajador_params)
        format.html { redirect_to trabajadores_path, notice: "Trabajador was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trabajadores/1 or /trabajadores/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to trabajadores_path, status: :see_other, notice: "Trabajador was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trabajador
      @objeto = Trabajador.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def trabajador_params
      params.expect(trabajador: [ :nombre, :rut, :clasificacion ])
    end
end
