class CalSemanasController < ApplicationController
  before_action :set_cal_semana, only: %i[ show ]

  # GET /cal_semanas or /cal_semanas.json
  def index
  end

  # GET /cal_semanas/1 or /cal_semanas/1.json
  def show
  end

  # GET /cal_semanas/new

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cal_semana
      @cal_semana = CalSemana.find(params[:id])
    end

end
