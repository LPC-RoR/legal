class Aplicacion::HlpAyudasController < ApplicationController
  before_action :set_hlp_ayuda, only: %i[ show ]

  # GET /hlp_ayudas or /hlp_ayudas.json
  def index
    @coleccion = HlpAyuda.all
  end

  # GET /hlp_ayudas/1 or /hlp_ayudas/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hlp_ayuda
      @hlp = params.expect(:id)
    end

    def get_rdrccn
      @rdrccn = @objeto.ownr
    end

    # Only allow a list of trusted parameters through.
    def hlp_ayuda_params
      params.expect(hlp_ayuda: [ :ownr_type, :ownr_id, :hlp_ayuda, :texto, :referencia ])
    end
end
