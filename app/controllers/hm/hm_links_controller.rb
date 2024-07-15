class Hm::HmLinksController < ApplicationController
  before_action :scrty_on
  before_action :set_hm_link, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /hm_links or /hm_links.json
  def index
    @coleccion = HmLink.all
  end

  # GET /hm_links/1 or /hm_links/1.json
  def show
  end

  # GET /hm_links/new
  def new
    parrafo = HmParrafo.find(params[:pid])
    n_ord = parrafo.hm_links.count + 1
    @objeto = HmLink.new(hm_parrafo_id: parrafo.id, orden: n_ord)
  end

  # GET /hm_links/1/edit
  def edit
  end

  # POST /hm_links or /hm_links.json
  def create
    @objeto = HmLink.new(hm_link_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Enlace fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hm_links/1 or /hm_links/1.json
  def update
    respond_to do |format|
      if @objeto.update(hm_link_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Enlace fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hm_links/1 or /hm_links/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Enlace fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hm_link
      @objeto = HmLink.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.hm_parrafo.hm_pagina
    end

    # Only allow a list of trusted parameters through.
    def hm_link_params
      params.require(:hm_link).permit(:orden, :hm_parrafo_id, :hm_link, :texto)
    end
end
