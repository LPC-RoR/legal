class ConsultoriasController < ApplicationController
  before_action :set_consultoria, only: %i[ show edit update destroy cambio_estado procesa_registros ]

  include Tarifas

  # GET /consultorias or /consultorias.json
  def index
  end

  # GET /consultorias/1 or /consultorias/1.json
  def show
  end

  # GET /consultorias/new
  def new
  end

  # GET /consultorias/1/edit
  def edit
  end

  # POST /consultorias or /consultorias.json
  def create
    @objeto = Consultoria.new(consultoria_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Consultoria was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consultorias/1 or /consultorias/1.json
  def update
    respond_to do |format|
      if @objeto.update(consultoria_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Consultoria was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consultorias/1 or /consultorias/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Consultoria was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consultoria
      @objeto = Consultoria.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/st_bandejas?m=Consultoria&e=#{@objeto.estado}"
    end

    # Only allow a list of trusted parameters through.
    def consultoria_params
      params.require(:consultoria).permit(:consultoria, :cliente_id, :estado, :tar_tarea_id)
    end
end
