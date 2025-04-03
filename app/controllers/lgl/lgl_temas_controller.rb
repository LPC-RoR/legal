class Lgl::LglTemasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_lgl_tema, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: %i[ destroy update ]

  include Orden

  # GET /lgl_temas or /lgl_temas.json
  def index
    @coleccion = LglTema.all
  end

  # GET /lgl_temas/1 or /lgl_temas/1.json
  def show
  end

  # GET /lgl_temas/new
  def new
    ownr = params[:oclss].constantize.find(params[:oid])
    @objeto = LglTema.new(ownr_type: params[:oclss], ownr_id: params[:oid], orden: ownr.lgl_temas.count + 1)
  end

  # GET /lgl_temas/1/edit
  def edit
  end

  # POST /lgl_temas or /lgl_temas.json
  def create
    @objeto = LglTema.new(lgl_tema_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tema fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_temas/1 or /lgl_temas/1.json
  def update
    respond_to do |format|
      if @objeto.update(lgl_tema_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tema fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgl_temas/1 or /lgl_temas/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, status: :see_other, notice: "Tema fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_tema
      @objeto = LglTema.find(params.expect(:id))
    end

    def get_rdrccn
      @rdrccn = @objeto.ownr
    end

    # Only allow a list of trusted parameters through.
    def lgl_tema_params
      params.expect(lgl_tema: [ :ownr_type, :ownr_id, :codigo, :orden, :lgl_tema, :heredado ])
    end
end
