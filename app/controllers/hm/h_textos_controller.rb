class Hm::HTextosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_htexto, only: %i[ show edit update destroy ]

  # GET /htextos or /htextos.json
  def index
    set_tabla('h_textos', HTexto.all, false)
  end

  # GET /htextos/1 or /htextos/1.json
  def show
  end

  # GET /htextos/new
  def new
    @objeto = HTexto.new
  end

  # GET /htextos/1/edit
  def edit
  end

  # POST /htextos or /htextos.json
  def create
    @objeto = HTexto.new(h_texto_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Texto fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /htextos/1 or /htextos/1.json
  def update
    respond_to do |format|
      if @objeto.update(h_texto_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Texto fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /htextos/1 or /htextos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Texto fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_htexto
      @objeto = HTexto.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = h_textos_path
    end

    # Only allow a list of trusted parameters through.
    def h_texto_params
      params.require(:h_texto).permit(:codigo, :h_texto, :texto, :imagen, :img_sz, :lnk_txt, :lnk)
    end
end
