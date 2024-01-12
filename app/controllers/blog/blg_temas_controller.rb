class Blog::BlgTemasController < ApplicationController
  before_action :set_blg_tema, only: %i[ show edit update destroy ]

  # GET /blg_temas or /blg_temas.json
  def index
    @coleccion = BlgTema.all
  end

  # GET /blg_temas/1 or /blg_temas/1.json
  def show
    set_tabla('blg_articulos', @objeto.blg_articulos.order(created_at: :desc), true)
  end

  # GET /blg_temas/new
  def new
    @objeto = BlgTema.new
  end

  # GET /blg_temas/1/edit
  def edit
  end

  # POST /blg_temas or /blg_temas.json
  def create
    @objeto = BlgTema.new(blg_tema_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tema fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blg_temas/1 or /blg_temas/1.json
  def update
    respond_to do |format|
      if @objeto.update(blg_tema_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tema fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blg_temas/1 or /blg_temas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tema fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blg_tema
      @objeto = BlgTema.find(params[:id])
    end

    def set_redireccion
      @redireccion = blg_articulos_path
    end

    # Only allow a list of trusted parameters through.
    def blg_tema_params
      params.require(:blg_tema).permit(:blg_tema, :imagen, :remove_imagen, :descripcion)
    end
end
