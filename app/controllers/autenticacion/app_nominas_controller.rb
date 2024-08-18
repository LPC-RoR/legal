class Autenticacion::AppNominasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :inicia_sesion
  before_action :set_app_nomina, only: %i[ show edit update destroy set_admin ]

  # GET /app_nominas or /app_nominas.json
  def index
    set_tabla('app_nominas', AppNomina.where.not(email: dog_email).order(:nombre), false)
  end

  # GET /app_nominas/1 or /app_nominas/1.json
  def show
  end

  # GET /app_nominas/new
  def new
    @objeto = AppNomina.new(tipo: 'Usuario')
  end

  # GET /app_nominas/1/edit
  def edit
  end

  # POST /app_nominas or /app_nominas.json
  def create
    @objeto = AppNomina.new(app_nomina_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Nomina de usuario fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_nominas/1 or /app_nominas/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_nomina_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Nomina de usuario fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_admin
    @objeto.tipo = @objeto.tipo == 'Usuario' ? 'Admin' : 'Usuario'
    @objeto.save

    redirect_to "/app_nominas", notice: "Se ha cambiado el tipo de usuario a #{@objeto.tipo}"
  end

  # DELETE /app_nominas/1 or /app_nominas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Nomina de usuario fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_nomina
      @objeto = AppNomina.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/app_nominas" 
    end

    # Only allow a list of trusted parameters through.
    def app_nomina_params
      params.require(:app_nomina).permit(:nombre, :email, :tipo)
    end
end
