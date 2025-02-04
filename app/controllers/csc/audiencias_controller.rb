class Csc::AudienciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_audiencia, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: %i[update destroy]

  include Orden

  # GET /audiencias or /audiencias.json
  def index
    @coleccion = Audiencia.all
  end

  # GET /audiencias/1 or /audiencias/1.json
  def show
  end

  # GET /audiencias/new
  def new
    tipo_causa = TipoCausa.find(params[:oid])
    @objeto = Audiencia.new(tipo_causa_id: tipo_causa.id, orden: tipo_causa.audiencias.count + 1 )
  end

  # GET /audiencias/1/edit
  def edit
  end

  # POST /audiencias or /audiencias.json
  def create
    @objeto = Audiencia.new(audiencia_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Audiencia fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /audiencias/1 or /audiencias/1.json
  def update
    respond_to do |format|
      if @objeto.update(audiencia_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Audiencia fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /audiencias/1 or /audiencias/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Audiencia fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audiencia
      @objeto = Audiencia.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/tablas/tipos"
    end

    # Only allow a list of trusted parameters through.
    def audiencia_params
      params.require(:audiencia).permit(:tipo_causa_id, :audiencia, :tipo , :orden)
    end
end
