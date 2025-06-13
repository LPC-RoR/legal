class Csc::TemasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tema, only: %i[ show edit update destroy arriba abajo ]
  after_action :ordena_temas, only: %i[ destroy ]

  # GET /temas or /temas.json
  def index
    @coleccion = Tema.all
  end

  # GET /temas/1 or /temas/1.json
  def show
  end

  # GET /temas/new
  def new
    causa = Causa.find(params[:oid])
    @objeto = Tema.new(causa_id: params[:oid], orden: causa.temas.count + 1)
  end

  # GET /temas/1/edit
  def edit
  end

  # POST /temas or /temas.json
  def create
    @objeto = Tema.new(tema_params)

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

  # PATCH/PUT /temas/1 or /temas/1.json
  def update
    respond_to do |format|
      if @objeto.update(tema_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tema fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def arriba
    owner = @objeto.owner
    anterior = @objeto.anterior
    @objeto.orden -= 1
    @objeto.save
    anterior.orden += 1
    anterior.save

    ordena_hechos

    redirect_to @objeto.redireccion
  end

  def abajo
    owner = @objeto.owner
    siguiente = @objeto.siguiente
    @objeto.orden += 1
    @objeto.save
    siguiente.orden -= 1
    siguiente.save

    ordena_hechos

    redirect_to @objeto.redireccion
  end

  # DELETE /temas/1 or /temas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tema fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    def ordena_temas
      causa = @objeto.causa
      ultimo_tema = 0
      # ordena temas
      causa.temas.order(:orden).each do |tema|
        tema.hechos.order(:orden).each do |hecho|
          hecho.orden = ultimo_tema + 1
          hecho.save
          ultimo_tema += 1
        end
      end

      ordena_hechos

    end

    def ordena_hechos
      causa = @objeto.causa
      ultimo_hecho = 0
      causa.temas.order(:orden).each do |tema|
        tema.hechos.order(:orden).each do |hecho|
          hecho.orden = ultimo_hecho + 1
          hecho.save
          ultimo_hecho += 1
        end
      end
      causa.hechos.where(tema_id: nil).order(:orden).each do |hecho|
          hecho.orden = ultimo_hecho + 1
          hecho.save
          ultimo_hecho += 1
      end 
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_tema
      @objeto = Tema.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/causas/#{@objeto.causa.id}?html_options[menu]=Hechos"
    end

    # Only allow a list of trusted parameters through.
    def tema_params
      params.require(:tema).permit(:causa_id, :orden, :tema, :descripcion)
    end
end
