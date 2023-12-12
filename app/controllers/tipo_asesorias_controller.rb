class TipoAsesoriasController < ApplicationController
  before_action :set_tipo_asesoria, only: %i[ show edit update destroy ]

  # GET /tipo_asesorias or /tipo_asesorias.json
  def index
    @tipo_asesorias = TipoAsesoria.all
  end

  # GET /tipo_asesorias/1 or /tipo_asesorias/1.json
  def show
  end

  # GET /tipo_asesorias/new
  def new
    @tipo_asesoria = TipoAsesoria.new
  end

  # GET /tipo_asesorias/1/edit
  def edit
  end

  # POST /tipo_asesorias or /tipo_asesorias.json
  def create
    @tipo_asesoria = TipoAsesoria.new(tipo_asesoria_params)

    respond_to do |format|
      if @tipo_asesoria.save
        format.html { redirect_to @tipo_asesoria, notice: "Tipo asesoria was successfully created." }
        format.json { render :show, status: :created, location: @tipo_asesoria }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tipo_asesoria.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_asesorias/1 or /tipo_asesorias/1.json
  def update
    respond_to do |format|
      if @tipo_asesoria.update(tipo_asesoria_params)
        format.html { redirect_to @tipo_asesoria, notice: "Tipo asesoria was successfully updated." }
        format.json { render :show, status: :ok, location: @tipo_asesoria }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tipo_asesoria.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_asesorias/1 or /tipo_asesorias/1.json
  def destroy
    @tipo_asesoria.destroy
    respond_to do |format|
      format.html { redirect_to tipo_asesorias_url, notice: "Tipo asesoria was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_asesoria
      @tipo_asesoria = TipoAsesoria.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tipo_asesoria_params
      params.require(:tipo_asesoria).permit(:tipo_asesoria, :facturable, :documento, :archivos)
    end
end
