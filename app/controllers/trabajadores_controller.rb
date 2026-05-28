class TrabajadoresController < ApplicationController
  before_action :set_trabajador, only: %i[ show edit update destroy ]

  # GET /trabajadores or /trabajadores.json
  def index
    @trabajadores = Trabajador.all
  end

  # GET /trabajadores/1 or /trabajadores/1.json
  def show
  end

  # GET /trabajadores/new
  def new
    @trabajador = Trabajador.new
  end

  # GET /trabajadores/1/edit
  def edit
  end

  # POST /trabajadores or /trabajadores.json
  def create
    @trabajador = Trabajador.new(trabajador_params)

    respond_to do |format|
      if @trabajador.save
        format.html { redirect_to @trabajador, notice: "Trabajador was successfully created." }
        format.json { render :show, status: :created, location: @trabajador }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trabajador.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trabajadores/1 or /trabajadores/1.json
  def update
    respond_to do |format|
      if @trabajador.update(trabajador_params)
        format.html { redirect_to @trabajador, notice: "Trabajador was successfully updated." }
        format.json { render :show, status: :ok, location: @trabajador }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trabajador.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trabajadores/1 or /trabajadores/1.json
  def destroy
    @trabajador.destroy!

    respond_to do |format|
      format.html { redirect_to trabajadores_path, status: :see_other, notice: "Trabajador was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trabajador
      @trabajador = Trabajador.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def trabajador_params
      params.expect(trabajador: [ :nombre, :rut ])
    end
end
