class ParrafosController < ApplicationController
  before_action :set_parrafo, only: %i[ show edit update destroy ]

  # GET /parrafos or /parrafos.json
  def index
    @coleccion = Parrafo.all
  end

  # GET /parrafos/1 or /parrafos/1.json
  def show
  end

  # GET /parrafos/new
  def new
    @objeto = Parrafo.new
  end

  # GET /parrafos/1/edit
  def edit
  end

  # POST /parrafos or /parrafos.json
  def create
    @objeto = Parrafo.new(parrafo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to parrafo_url(@objeto), notice: "Párrafo fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parrafos/1 or /parrafos/1.json
  def update
    respond_to do |format|
      if @objeto.update(parrafo_params)
        format.html { redirect_to parrafo_url(@objeto), notice: "Párrafo fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parrafos/1 or /parrafos/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to parrafos_url, notice: "Párrafo fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parrafo
      @objeto = Parrafo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def parrafo_params
      params.require(:parrafo).permit(:causa_id, :seccion_id, :orden, :orden, :texto)
    end
end
