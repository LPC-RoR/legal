class Actividades::AgeUsuariosController < ApplicationController
  before_action :set_age_usuario, only: %i[ show edit update destroy asigna_perfil desasigna_perfil ]

  # GET /age_usuarios or /age_usuarios.json
  def index
    @coleccion = AgeUsuario.all
  end

  # GET /age_usuarios/1 or /age_usuarios/1.json
  def show
  end

  # GET /age_usuarios/new
  def new
    @objeto = AgeUsuario.new
  end

  # GET /age_usuarios/1/edit
  def edit
  end

  # POST /age_usuarios or /age_usuarios.json
  def create
    @objeto = AgeUsuario.new(age_usuario_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Usuarios de agenda ha sido exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /age_usuarios/1 or /age_usuarios/1.json
  def update
    respond_to do |format|
      if @objeto.update(age_usuario_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Usuarios de agenda ha sido exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def asigna_perfil
    if perfil_activo.age_usuarios.empty?
      @objeto.app_perfil_id = perfil_activo.id
      @objeto.save
      noticia = "Perfil asignado exitósamente al usuario de agenda"
    else
      noticia = "Error de asignación: Este perfil ya tiene un usuario asignado"
    end

    redirect_to "/tablas/agenda", notice: noticia
  end

  def desasigna_perfil
    @objeto.app_perfil_id = nil
    @objeto.save

    redirect_to "/tablas/agenda", notice: "Perfil desasignado exitósamente"
  end

  # DELETE /age_usuarios/1 or /age_usuarios/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Usuarios de agenda ha sido exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_age_usuario
      @objeto = AgeUsuario.find(params[:id])
    end

    def set_redireccion
      @redireccion = tabla_path(@objeto)
    end

    # Only allow a list of trusted parameters through.
    def age_usuario_params
      params.require(:age_usuario).permit(:owner_class, :owner_id, :age_usuario)
    end
end
