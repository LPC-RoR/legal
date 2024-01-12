class Blog::BlgArticulosController < ApplicationController
  before_action :set_blg_articulo, only: %i[ show edit update destroy ]

  # GET /blg_articulos or /blg_articulos.json
  def index
    if admin?
      set_tabla('perfil-blg_articulos', perfil_activo.blg_articulos.order(created_at: :desc), true)
      set_tabla('general-blg_articulos', BlgArticulo.all.order(created_at: :desc), true)
      set_tabla('blg_temas', BlgTema.all.order(created_at: :desc), true)
    else
      set_tabla('perfil-blg_articulos', perfil_activo.blg_articulos.order(created_at: :desc), true)
    end
  end

  # GET /blg_articulos/1 or /blg_articulos/1.json
  def show
  end

  # GET /blg_articulos/new
  def new
    @objeto = perfil_activo.blg_articulos.new(estado: 'ingreso')
  end

  # GET /blg_articulos/1/edit
  def edit
  end

  # POST /blg_articulos or /blg_articulos.json
  def create
    @objeto = BlgArticulo.new(blg_articulo_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Artículo fue exitósamente creado" }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blg_articulos/1 or /blg_articulos/1.json
  def update
    respond_to do |format|
      if @objeto.update(blg_articulo_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Artículo fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blg_articulos/1 or /blg_articulos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Artículo fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blg_articulo
      @objeto = BlgArticulo.find(params[:id])
    end

    def set_redireccion
      @redireccion = blg_articulos_path
    end

    # Only allow a list of trusted parameters through.
    def blg_articulo_params
      params.require(:blg_articulo).permit(:blg_articulo, :app_perfil_id, :blg_tema_id, :estado, :articulo, :imagen, :remove_imagen, :descripcion, :autor)
    end
end
