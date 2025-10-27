class Aplicacion::SlidesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_slide, only: %i[ show edit update destroy arriba abajo]
  after_action :reordenar, only: :destroy

  include Orden

  # GET /slides or /slides.json
  def index
    @slides = Slide.list
  end

  # GET /slides/1 or /slides/1.json
  def show
  end

  # GET /slides/new
  def new
    @objeto = Slide.new(orden: Slide.list.count + 1)
  end

  # GET /slides/1/edit
  def edit
  end

  # POST /slides or /slides.json
  def create
    @objeto = Slide.new(slide_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Slide fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /slides/1 or /slides/1.json
  def update
    respond_to do |format|
      if @objeto.update(slide_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Slide fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slides/1 or /slides/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to slides_path, status: :see_other, notice: "Slide fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slide
      @objeto = Slide.find(params.expect(:id))
    end

    def get_rdrccn
      @rdrccn = slides_path
    end

    # Only allow a list of trusted parameters through.
    def slide_params
      params.expect(slide: [ :orden, :desactivar, :nombre, :txt, :imagen, :derechos ])
    end
end
