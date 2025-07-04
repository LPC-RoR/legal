class Csc::AntecedentesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_antecedente, only: %i[ show edit update destroy arriba abajo ]

  # GET /antecedentes or /antecedentes.json
  def index
    @coleccion = Antecedente.all
  end

  # GET /antecedentes/1 or /antecedentes/1.json
  def show
  end

  # GET /antecedentes/new
  def new
    hecho = Hecho.find(params[:oid])
    causa_id = hecho.causa_id.present? ? hecho.causa_id : hecho.tema.causa_id
    @objeto = hecho.antecedentes.new(causa_id: causa_id, orden: hecho.antecedentes.count + 1)
  end

  # GET /antecedentes/1/edit
  def edit
  end

  # POST /antecedentes or /antecedentes.json
  def create
    @objeto = Antecedente.new(antecedente_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Antecedente fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /antecedentes/1 or /antecedentes/1.json
  def update
    respond_to do |format|
      if @objeto.update(antecedente_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Antecedente fue exitosamente actualizado." }
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
    if @objeto.hecho_id == anterior.hecho_id
      @objeto.orden -= 1
      @objeto.save
      anterior.orden += 1
      anterior.save
    else
      @objeto.hecho_id = anterior.hecho_id
      @objeto.save
    end

    redirect_to @objeto.redireccion
  end

  def abajo
    owner = @objeto.owner
    siguiente = @objeto.siguiente
    if @objeto.hecho_id == siguiente.hecho_id
      @objeto.orden += 1
      @objeto.save
      siguiente.orden -= 1
      siguiente.save
    else
      @objeto.hecho_id = siguiente.hecho_id
      @objeto.save
    end

    redirect_to @objeto.redireccion
  end

  # DELETE /antecedentes/1 or /antecedentes/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Antecedente fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_antecedente
      @objeto = Antecedente.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/causas/#{@objeto.causa.id}?html_options[menu]=Hechos"
    end

    # Only allow a list of trusted parameters through.
    def antecedente_params
      params.require(:antecedente).permit(:hecho_id, :riesgo, :ventaja, :cita, :orden, :causa_id, :solicitud)
    end
end
