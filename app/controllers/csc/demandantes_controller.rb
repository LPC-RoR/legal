class Csc::DemandantesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_demandante, only: %i[ show edit update destroy ]

  # GET /demandantes or /demandantes.json
  def index
    @coleccion = Demandante.all
  end

  # GET /demandantes/1 or /demandantes/1.json
  def show
  end

  # GET /demandantes/new
  def new
    causa = Causa.find(params[:cid])
    @objeto = Demandante.new(causa_id: causa.id, orden: causa.demandantes.count + 1)
  end

  # GET /demandantes/1/edit
  def edit
  end

  # POST /demandantes or /demandantes.json
  def create
    @objeto = Demandante.new(demandante_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Demandante fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /demandantes/1 or /demandantes/1.json
  def update
    respond_to do |format|
      if @objeto.update(demandante_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Demandante fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /demandantes/1 or /demandantes/1.json
  def destroy
    set_redireccion
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Demandante fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_demandante
      @objeto = Demandante.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/causas/#{@objeto.causa.id}?html_options[menu]=#{CGI.escape('Datos & Cuantía')}"
    end

    # Only allow a list of trusted parameters through.
    def demandante_params
      params.require(:demandante).permit(:causa_id, :orden, :nombres, :apellidos, :remuneracion, :cargo, :lugar_trabajo)
    end
end
