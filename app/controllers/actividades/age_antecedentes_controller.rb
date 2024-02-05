class Actividades::AgeAntecedentesController < ApplicationController
  before_action :set_age_antecedente, only: %i[ show edit update destroy arriba abajo elimina_antecedente ]
  after_action :reordenar, only: :destroy

  # GET /age_antecedentes or /age_antecedentes.json
  def index
    @coleccion = AgeAntecedente.all
  end

  # GET /age_antecedentes/1 or /age_antecedentes/1.json
  def show
  end

  # GET /age_antecedentes/new
  def new
    actividad = AgeActividad.find(params[:aid])
    @objeto = AgeAntecedente.new(orden: actividad.age_antecedentes.count + 1, age_actividad_id: actividad.id)
  end

  # GET /age_antecedentes/1/edit
  def edit
  end

  # POST /age_antecedentes or /age_antecedentes.json
  def create
    @objeto = AgeAntecedente.new(age_antecedente_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Antecedente fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /age_antecedentes/1 or /age_antecedentes/1.json
  def update
    respond_to do |format|
      if @objeto.update(age_antecedente_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Antecedente fue exitósamente actualizado." }
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

    redirect_to @objeto.redireccion
  end

  def abajo
    owner = @objeto.owner
    siguiente = @objeto.siguiente
    @objeto.orden += 1
    @objeto.save
    siguiente.orden -= 1
    siguiente.save

    redirect_to @objeto.redireccion
  end

  def elimina_antecedente
    causa = @objeto.age_actividad.owner
    @objeto.delete

    redirect_to ( params[:c] == 'age_actividades' ? '/age_actividades' : causa )
  end

  # DELETE /age_antecedentes/1 or /age_antecedentes/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Antecedente fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    def reordenar
      @objeto.list.each_with_index do |val, index|
        unless val.orden == index + 1
          val.orden = index + 1
          val.save
        end
      end
    end

     # Use callbacks to share common setup or constraints between actions.
    def set_age_antecedente
      @objeto = AgeAntecedente.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.age_actividad.owner
    end

    # Only allow a list of trusted parameters through.
    def age_antecedente_params
      params.require(:age_antecedente).permit(:orden, :age_antecedente, :age_actividad_id)
    end
end
