class Actividades::AgePendientesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_age_pendiente, only: %i[ show edit update destroy realizado_pendiente cambia_prioridad ]

  # GET /age_pendientes or /age_pendientes.json
  def index
    @coleccion = AgePendiente.all
  end

  # GET /age_pendientes/1 or /age_pendientes/1.json
  def show
  end

  # GET /age_pendientes/new
  def new
    @objeto = AgePendiente.new(age_usuario_id: params[:oid], estado: 'pendiente')
  end

  # GET /age_pendientes/1/edit
  def edit
  end

  # POST /age_pendientes or /age_pendientes.json
  def create
    @objeto = AgePendiente.new(age_pendiente_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Pendiente fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /age_pendientes/1 or /age_pendientes/1.json
  def update
    respond_to do |format|
      if @objeto.update(age_pendiente_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Pendiente fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def realizado_pendiente
    @objeto.estado = ( @objeto.estado == 'pendiente' ? 'realizado' : 'pendiente' )
    @objeto.save

    redirect_to "/age_actividades"
  end

  def cambia_prioridad
    # {negro, verde, amarillo, rojo}
    @objeto.prioridad = params[:prioridad] == 'nil' ? nil : params[:prioridad]
    @objeto.save

    redirect_to "/age_actividades"
  end

  # DELETE /age_pendientes/1 or /age_pendientes/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Pendiente fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_age_pendiente
      @objeto = AgePendiente.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/age_actividades"
    end

    # Only allow a list of trusted parameters through.
    def age_pendiente_params
      params.require(:age_pendiente).permit(:age_usuario_id, :age_pendiente, :estado, :prioridad)
    end
end
