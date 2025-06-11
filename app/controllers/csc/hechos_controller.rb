class Csc::HechosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_hecho, only: %i[ show edit update destroy nuevo_archivo sel_archivo arriba abajo set_evaluacion nuevo_antecedente ]
  after_action :ordena_hechos, only: %i[ create destroy update nuevo_antecedente ]

  # GET /hechos or /hechos.json
  def index
    @coleccion = Hecho.all
  end

  # GET /hechos/1 or /hechos/1.json
  def show
  end

  # GET /hechos/new
  def new
    # Al crear un hecho el orden siempre se refiera a la Causa, al estar dentro de una Materia en particular conservan ese oreden
    owner = params[:oclss].constantize.find(params[:oid])
    tema_id = owner.class.name == 'Causa' ? nil : owner.id
    causa = owner.class.name == 'Causa' ? owner : owner.causa
    @objeto = Hecho.new(tema_id: tema_id, causa_id: causa.id, orden: causa.hechos.count + 1)
  end

  # GET /hechos/1/edit
  def edit
  end

  # POST /hechos or /hechos.json
  def create
    @objeto = Hecho.new(hecho_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Hecho fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hechos/1 or /hechos/1.json
  def update
    respond_to do |format|
      if @objeto.update(hecho_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Hecho fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def nuevo_antecedente
    f_prms = params[:nuevo_antecedente]
    unless f_prms[:solicitud].blank?
      @objeto.antecedentes.create(causa_id: @objeto.causa.id, hecho_id: @objeto.id, solicitud: f_prms[:solicitud], orden: @objeto.antecedentes.count + 1)
    end

    redirect_to "/causas/#{@objeto.causa.id}?html_options[menu]=Hechos"
  end

  def set_evaluacion
    case params[:c]
    when 'c'
      @objeto.st_contestacion = params[:e] == 'nil' ? nil : params[:e]
    when 'p'
      @objeto.st_preparatoria = params[:e] == 'nil' ? nil : params[:e]
    end
    @objeto.save

    redirect_to "/causas/#{@objeto.causa.id}?html_options[menu]=Hechos"
  end

  def arriba
    owner = @objeto.owner
    anterior = @objeto.anterior
    if @objeto.tema_id == anterior.tema_id
      @objeto.orden -= 1
      @objeto.save
      anterior.orden += 1
      anterior.save
    else
      @objeto.tema_id = anterior.tema_id
      @objeto.save
    end

    redirect_to @objeto.redireccion
  end

  def abajo
    owner = @objeto.owner
    siguiente = @objeto.siguiente
    if @objeto.tema_id == siguiente.tema_id
      @objeto.orden += 1
      @objeto.save
      siguiente.orden -= 1
      siguiente.save
    else
      @objeto.tema_id = siguiente.tema_id
      @objeto.save
    end

    redirect_to @objeto.redireccion
  end

  # via: :post, on: :member Se usa desde un collapse en despliegue de Hechos
  def nuevo_archivo
    unless params[:nuevo_archivo][:nombre].blank?
      archivo = AppArchivo.create(app_archivo: params[:nuevo_archivo][:nombre])
      causa = @objeto.causa

      causa.causa_archivos.create(orden: causa.causa_archivos.count + 1, app_archivo_id: archivo.id)
      @objeto.app_archivos << archivo
    end

    redirect_to "/causas/#{causa.id}?html_options[menu]=Hechos"
  end

  def sel_archivo
    unless params[:aid].blank?
      archivo = AppArchivo.find(params[:aid])
      causa = @objeto.causa
      @objeto.app_archivos << archivo unless @objeto.app_archivos.ids.include?(archivo.id)
    end

    redirect_to "/causas/#{causa.id}?html_options[menu]=Hechos"
  end

  # DELETE /hechos/1 or /hechos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Hecho fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    def ordena_hechos
      causa = @objeto.causa
      ultimo_hecho = 0
      ultimo_antecedente = 0
      causa.temas.order(:orden).each do |tema|
        tema.hechos.order(:orden).each do |hecho|
          hecho.orden = ultimo_hecho + 1
          hecho.save
          ultimo_hecho += 1
          hecho.antecedentes.order(:orden).each do |antec|
            antec.orden = ultimo_antecedente + 1
            antec.save
            ultimo_antecedente += 1
          end
        end
      end
      causa.hechos.where(tema_id: nil).order(:orden).each do |hecho|
          hecho.orden = ultimo_hecho + 1
          hecho.save
          ultimo_hecho += 1
          hecho.antecedentes.order(:orden).each do |antec|
            antec.orden = ultimo_antecedente + 1
            antec.save
            ultimo_antecedente += 1
          end
      end 
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_hecho
      @objeto = Hecho.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/causas/#{@objeto.causa.id}?html_options[menu]=Hechos"
    end

    # Only allow a list of trusted parameters through.
    def hecho_params
      params.require(:hecho).permit(:tema_id, :causa_id, :orden, :hecho, :cita, :archivo, :documento, :paginas, :descripcion)
    end
end
