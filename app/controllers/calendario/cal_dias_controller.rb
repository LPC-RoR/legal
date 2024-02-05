class CalDiasController < ApplicationController
  before_action :set_cal_dia, only: %i[ show ]

  # GET /cal_dias or /cal_dias.json
  def index
  end

  # GET /cal_dias/1 or /cal_dias/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cal_dia
      @cal_dia = CalDia.find(params[:id])
    end

end
