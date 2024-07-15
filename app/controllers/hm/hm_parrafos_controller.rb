class Hm::HmParrafosController < ApplicationController
  before_action :scrty_on
  before_action :set_hm_parrafo, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /hm_parrafos or /hm_parrafos.json
  def index
    @coleccion = HmParrafo.all
  end

  # GET /hm_parrafos/1 or /hm_parrafos/1.json
  def show
  end

  # GET /hm_parrafos/new
  def new
    pagina = HmPagina.find(params[:pid])
    n_parr = pagina.hm_parrafos.count + 1
    @objeto = HmParrafo.new(hm_pagina_id: pagina.id, orden: n_parr)
  end

  # GET /hm_parrafos/1/edit
  def edit
  end

  # POST /hm_parrafos or /hm_parrafos.json
  def create
    @objeto = HmParrafo.new(hm_parrafo_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Parrafo fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hm_parrafos/1 or /hm_parrafos/1.json
  def update
    respond_to do |format|
      if @objeto.update(hm_parrafo_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Parrafo fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hm_parrafos/1 or /hm_parrafos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Parrafo fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hm_parrafo
      @objeto = HmParrafo.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.hm_pagina
    end

    # Only allow a list of trusted parameters through.
    def hm_parrafo_params
      params.require(:hm_parrafo).permit(:hm_pagina_id, :orden, :hm_parrafo, :tipo, :imagen, :img_lyt, :menu_lft)
    end
end
