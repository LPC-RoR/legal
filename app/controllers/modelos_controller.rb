class ModelosController < ApplicationController
  before_action :set_modelo, only: %i[ show edit update destroy ]

  # GET /modelos or /modelos.json
  def index
    @modelos = Modelo.all
  end

  # GET /modelos/1 or /modelos/1.json
  def show
  end

  # GET /modelos/new
  def new
    @modelo = Modelo.new
  end

  # GET /modelos/1/edit
  def edit
  end

  # POST /modelos or /modelos.json
  def create
    @modelo = Modelo.new(modelo_params)

    respond_to do |format|
      if @modelo.save
        format.html { redirect_to @modelo, notice: "Modelo was successfully created." }
        format.json { render :show, status: :created, location: @modelo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @modelo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modelos/1 or /modelos/1.json
  def update
    respond_to do |format|
      if @modelo.update(modelo_params)
        format.html { redirect_to @modelo, notice: "Modelo was successfully updated." }
        format.json { render :show, status: :ok, location: @modelo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @modelo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modelos/1 or /modelos/1.json
  def destroy
    @modelo.destroy!

    respond_to do |format|
      format.html { redirect_to modelos_path, status: :see_other, notice: "Modelo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modelo
      @modelo = Modelo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def modelo_params
      params.fetch(:modelo, {})
    end
end
