class Blog::BlgImagenesController < ApplicationController
  before_action :set_blg_imagen, only: %i[ show edit update destroy ]

  # GET /blg_imagenes or /blg_imagenes.json
  def index
    @coleccion = BlgImagen.all
  end

  # GET /blg_imagenes/1 or /blg_imagenes/1.json
  def show
  end

  # GET /blg_imagenes/new
  def new
    @objeto = BlgImagen.new
  end

  # GET /blg_imagenes/1/edit
  def edit
  end

  # POST /blg_imagenes or /blg_imagenes.json
  def create
    @objeto = BlgImagen.new(blg_imagen_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Imagen fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blg_imagenes/1 or /blg_imagenes/1.json
  def update
    respond_to do |format|
      if @objeto.update(blg_imagen_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Imagen fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blg_imagenes/1 or /blg_imagenes/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Imagen fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blg_imagen
      @objeto = BlgImagen.find(params[:id])
    end

    def set_redireccion
      @redireccion = self.owner
    end

    # Only allow a list of trusted parameters through.
    def blg_imagen_params
      params.require(:blg_imagen).permit(:blg_imagen, :imagen, :blg_credito, :ownr_class, :ownr_id)
    end
end
