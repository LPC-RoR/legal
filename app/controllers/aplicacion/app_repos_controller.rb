class Aplicacion::AppReposController < ApplicationController
  before_action :set_app_repo, only: %i[ show edit update destroy ]

  # GET /app_repos or /app_repos.json
  def index
    @coleccion = AppRepo.all
  end

  # GET /app_repos/1 or /app_repos/1.json
  def show
    if ['Cliente', 'Causa'].include?(@objeto.owner_class)
      redirect_to @objeto.owner_class.constantize.find(@objeto.owner_id)
    else
      @coleccion = {}
      @coleccion['app_documentos'] = @objeto.documentos.order(:documento)
      @coleccion['app_directorios'] = @objeto.directorios.order(:directorio)
    end
  end

  def publico
    publico = AppRepo.find_by(repositorio: 'Público')
    publico = AppRepo.create(repositorio: 'Público') if publico.blank?

    redirect_to publico
  end

  def perfil
    perfil = AppRepo.where(owner_class: 'AppPerfil').find_by(owner_id: perfil_activo.id)
    perfil = AppRepo.create(repositorio: perfil_activo.email, owner_class: 'AppPerfil', owner_id: perfil_activo.id) if perfil.blank?

    redirect_to perfil
  end

  # GET /app_repos/new
  def new
    @objeto = AppRepo.new
  end

  # GET /app_repos/1/edit
  def edit
  end

  # POST /app_repos or /app_repos.json
  def create
    @objeto = AppRepo.new(app_repo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "App repo was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
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
      @objeto = AppRepo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_repo_params
      params.require(:app_repo).permit(:repositorio, :owner_class, :owner_id)
    end
end
