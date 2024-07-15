class Hm::HmPaginasController < ApplicationController
  before_action :scrty_on
  before_action :set_hm_pagina, only: %i[ show edit update destroy ]

  # GET /hm_paginas or /hm_paginas.json
  def index
    set_tabla('hm_paginas', HmPagina.all, true)
  end

  # GET /hm_paginas/1 or /hm_paginas/1.json
  def show
    set_tabla('hm_parrafos', @objeto.hm_parrafos.order(:orden), true)
  end

  # GET /hm_paginas/new
  def new
    @objeto = HmPagina.new
  end

  # GET /hm_paginas/1/edit
  def edit
  end

  # POST /hm_paginas or /hm_paginas.json
  def create
    @objeto = HmPagina.new(hm_pagina_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Pagina fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hm_paginas/1 or /hm_paginas/1.json
  def update
    respond_to do |format|
      if @objeto.update(hm_pagina_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Pagina fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hm_paginas/1 or /hm_paginas/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Pagina fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hm_pagina
      @objeto = HmPagina.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = hm_paginas_path
    end

    # Only allow a list of trusted parameters through.
    def hm_pagina_params
      params.require(:hm_pagina).permit(:ownr_clss, :ownr_id, :codigo, :hm_pagina, :tooltip, :menu_lft)
    end
end
