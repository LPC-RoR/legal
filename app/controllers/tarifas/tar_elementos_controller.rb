class Tarifas::TarElementosController < ApplicationController
  before_action :set_tar_elemento, only: %i[ show edit update destroy ]

  # GET /tar_elementos or /tar_elementos.json
  def index
  end

  # GET /tar_elementos/1 or /tar_elementos/1.json
  def show
  end

  # GET /tar_elementos/new
  def new
    @objeto = TarElemento.new
  end

  # GET /tar_elementos/1/edit
  def edit
  end

  # POST /tar_elementos or /tar_elementos.json
  def create
    @objeto = TarElemento.new(tar_elemento_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar elemento was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_elementos/1 or /tar_elementos/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_elemento_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar elemento was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_elementos/1 or /tar_elementos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tar elemento was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_elemento
      @objeto = TarElemento.find(params[:id])
    end

    def set_redireccion
    end

    # Only allow a list of trusted parameters through.
    def tar_elemento_params
      params.require(:tar_elemento).permit(:elemento, :codigo)
    end
end
