class Aplicacion::PublicosController < ApplicationController
  before_action :scrty_on, only: %i[ home home_prueba ]
  before_action :inicia_sesion, only: [:home]
#  before_action :check_user_confirmation, if: :user_signed_in?
  # GET /publicos or /publicos.json
  def index
  end

  private

    # Only allow a list of trusted parameters through.
    def publico_params
      params.fetch(:publico, {})
    end
end
