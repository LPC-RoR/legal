class Csc::EstadosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_estado, only: %i[ show edit update destroy ]

  # GET /estados or /estados.json
  def index
    @coleccion = Estado.all
  end

  # GET /estados/1 or /estados/1.json
  def show
  end

  # GET /estados/new
  def new
    @objeto = Estado.new(causa_id: params[:oid])
  end

  # GET /estados/1/edit
  def edit
  end

  # POST /estados or /estados.json
  def create
    @objeto = Estado.new(estado_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Estado fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /estados/1 or /estados/1.json
  def update
    respond_to do |format|
      if @objeto.update(estado_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Estado fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estados/1 or /estados/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Estado fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_estado
      @objeto = Estado.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = "/causas/#{@objeto.causa.id}"
    end

    # Only allow a list of trusted parameters through.
    def estado_params
      params.require(:estado).permit(:causa_id, :link, :estado, :urgente)
    end
end
