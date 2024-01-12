class Repositorios::AppRepositoriosController < ApplicationController
  before_action :set_app_repo, only: %i[ show edit update destroy ]

#  include Bandejas

  # GET /app_repos or /app_repos.json
  def index
    if usuario_signed_in?
      # Repositorio de la plataforma
      general_sha1 = Digest::SHA1.hexdigest("Repositorio General")
      @repositorio_general = AppRepositorio.find_by(app_repositorio: general_sha1)
      @repositorio_general = AppRepositorio.create(app_repositorio: general_sha1) if @repositorio_general.blank?

      # Repositorio_perfil
      if perfil_activo.repositorio.blank?
        @repositorio_perfil = AppRepositorio.create(app_repositorio: perfil_activo.email, owner_class: 'AppPerfil', owner_id: perfil_activo.id)
      else
        @repositorio_perfil = perfil_activo.repositorio
      end

      set_tabla('general-app_directorios', @repositorio_general.directorios.order(:app_directorio), false)
      set_tabla('general-app_documentos', @repositorio_general.documentos.order(:app_documento), false) 
      set_tabla('general-app_archivos', @repositorio_general.archivos.order(:app_archivo), false) 
      set_tabla('perfil-app_directorios', @repositorio_perfil.directorios.order(:app_directorio), false)
      set_tabla('perfil-app_documentos', @repositorio_perfil.documentos.order(:app_documento), false)
      set_tabla('perfil-app_archivos', @repositorio_perfil.archivos.order(:app_archivo), false) 
    end
  end

  # GET /app_repos/1 or /app_repos/1.json
  def show
    init_bandejas

    if ['Cliente', 'Causa'].include?(@objeto.owner_class)
      redirect_to @objeto.owner_class.constantize.find(@objeto.owner_id)
    else
      set_tabla('app_documentos', @objeto.documentos.order(:app_documento), false)
      set_tabla('app_directorios', @objeto.directorios.order(:app_directorio), false)
    end
  end

  def publico
    publico = AppRepositorio.find_by(app_repositorio: 'Público')
    publico = AppRepositorio.create(app_repositorio: 'Público') if publico.blank?

    redirect_to publico
  end

  def perfil
    perfil = AppRepositorio.where(owner_class: 'AppPerfil').find_by(owner_id: perfil_activo.id)
    perfil = AppRepositorio.create(app_repositorio: perfil_activo.email, owner_class: 'AppPerfil', owner_id: perfil_activo.id) if perfil.blank?

    redirect_to perfil
  end

  # GET /app_repos/new
  def new
    @objeto = AppRepositorio.new
  end

  # GET /app_repos/1/edit
  def edit
  end

  # POST /app_repos or /app_repos.json
  def create
    @objeto = AppRepositorio.new(app_repo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "App repo was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
        format.turbo_stream { render "0p/form/form_update", status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_repos/1 or /app_repos/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_repo_params)
        format.html { redirect_to @objeto, notice: "App repo was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_repos/1 or /app_repos/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to app_repos_url, notice: "App repo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_repo
      @objeto = AppRepositorio.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_repo_params
      params.require(:app_repositorio).permit(:app_repositorio, :owner_class, :owner_id)
    end
end
