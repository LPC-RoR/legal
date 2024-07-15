class Hm::HmNotasController < ApplicationController
  before_action :scrty_on
  before_action :set_hm_nota, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /hm_notas or /hm_notas.json
  def index
    @coleccion = HmNota.all
  end

  # GET /hm_notas/1 or /hm_notas/1.json
  def show
  end

  # GET /hm_notas/new
  def new
    parrafo = HmParrafo.find(params[:pid])
    n_ord = parrafo.hm_notas.count + 1
    @objeto = HmNota.new(hm_parrafo_id: parrafo.id, orden: n_ord)
  end

  # GET /hm_notas/1/edit
  def edit
  end

  # POST /hm_notas or /hm_notas.json
  def create
    @objeto = HmNota.new(hm_nota_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Nota fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hm_notas/1 or /hm_notas/1.json
  def update
    respond_to do |format|
      if @objeto.update(hm_nota_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Nota fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hm_notas/1 or /hm_notas/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Nota fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hm_nota
      @objeto = HmNota.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.hm_parrafo.hm_pagina
    end

    # Only allow a list of trusted parameters through.
    def hm_nota_params
      params.require(:hm_nota).permit(:hm_parrafo_id, :orden, :hm_nota)
    end
end
