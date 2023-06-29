class Tarifas::TarUfSistemasController < ApplicationController
  before_action :set_tar_uf_sistema, only: %i[ show edit update destroy ]

  # GET /tar_uf_sistemas or /tar_uf_sistemas.json
  def index
    @cooleccion = TarUfSistema.all
  end

  # GET /tar_uf_sistemas/1 or /tar_uf_sistemas/1.json
  def show
  end

  # GET /tar_uf_sistemas/new
  def new
    @objeto = TarUfSistema.new
  end

  # GET /tar_uf_sistemas/1/edit
  def edit
  end

  # POST /tar_uf_sistemas or /tar_uf_sistemas.json
  def create
    @objeto = TarUfSistema.new(tar_uf_sistema_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "UF fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_uf_sistemas/1 or /tar_uf_sistemas/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_uf_sistema_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "UF fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_uf_sistemas/1 or /tar_uf_sistemas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "UF fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_uf_sistema
      @objeto = TarUfSistema.find(params[:id])
    end

    def set_redireccion
      @redireccion = '/app_recursos/tablas?html_options[tablas]=Tarifas+Generales+%26+UF'
    end

    # Only allow a list of trusted parameters through.
    def tar_uf_sistema_params
      params.require(:tar_uf_sistema).permit(:fecha, :valor)
    end
end
