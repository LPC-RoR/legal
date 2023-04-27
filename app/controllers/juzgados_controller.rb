class JuzgadosController < ApplicationController
  before_action :set_juzgado, only: %i[ show edit update destroy ]

  # GET /juzgados or /juzgados.json
  def index
    @coleccion = Juzgado.all
  end

  # GET /juzgados/1 or /juzgados/1.json
  def show
  end

  # GET /juzgados/new
  def new
    @objeto = Juzgado.new
  end

  # GET /juzgados/1/edit
  def edit
  end

  # POST /juzgados or /juzgados.json
  def create
    @objeto = Juzgado.new(juzgado_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Juzgado was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /juzgados/1 or /juzgados/1.json
  def update
    respond_to do |format|
      if @objeto.update(juzgado_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Juzgado was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /juzgados/1 or /juzgados/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Juzgado was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_juzgado
      @objeto = Juzgado.find(params[:id])
    end

    def set_redireccion
      @redireccion = '/app_recursos/tablas?html_options[tablas]=Cuantías+%26+Juzgados'
    end

    # Only allow a list of trusted parameters through.
    def juzgado_params
      params.require(:juzgado).permit(:juzgado)
    end
end
