class Autenticacion::AutTipoUsuariosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_aut_tipo_usuario, only: %i[ show edit update destroy ]

  # GET /aut_tipo_usuarios or /aut_tipo_usuarios.json
  def index
    set_tabla('aut_tipo_usuarios', AutTipoUsuario.all.order(:aut_tipo_usuario), false)
  end

  # GET /aut_tipo_usuarios/1 or /aut_tipo_usuarios/1.json
  def show
  end

  # GET /aut_tipo_usuarios/new
  def new
    @objeto = AutTipoUsuario.new
  end

  # GET /aut_tipo_usuarios/1/edit
  def edit
  end

  # POST /aut_tipo_usuarios or /aut_tipo_usuarios.json
  def create
    @objeto = AutTipoUsuario.new(aut_tipo_usuario_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tipo de usuario fue exitósamente agregado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aut_tipo_usuarios/1 or /aut_tipo_usuarios/1.json
  def update
    respond_to do |format|
      if @objeto.update(aut_tipo_usuario_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tipo de usuario fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /aut_tipo_usuarios/1 or /aut_tipo_usuarios/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tipo de usuario fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aut_tipo_usuario
      @objeto = AutTipoUsuario.find(params[:id])
    end

    def set_redireccion
      @redireccion = aut_tipo_usuarios_path
    end

    # Only allow a list of trusted parameters through.
    def aut_tipo_usuario_params
      params.require(:aut_tipo_usuario).permit(:aut_tipo_usuario)
    end
end
