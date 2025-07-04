class Autenticacion::AppVersionesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_app_version, only: %i[ edit update show ]

  # GET /app_versiones or /app_versiones.json
  def index
    set_tabla('app_versiones', AppVersion.all, false)
  end

  # GET /app_versiones/1/edit
  def edit
  end

  def show
    set_tabla('rep_archivos', @objeto.rep_archivos, false)
    set_tabla('cfg_valores', @objeto.cfg_valores, false)
  end

  # PATCH/PUT /app_versiones/1 or /app_versiones/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_version_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Version fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_version
      @objeto = AppVersion.find(params[:id])
    end

    def set_redireccion
      @redireccion = '/app_versiones'
    end

    # Only allow a list of trusted parameters through.
    def app_version_params
      params.require(:app_version).permit(:app_nombre, :app_sigla, :app_logo, :app_banner)
    end
end
