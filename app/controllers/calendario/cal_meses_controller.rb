class Calendario::CalMesesController < ApplicationController
  before_action :set_cal_mes, only: %i[ show ]

  # GET /cal_meses or /cal_meses.json
  def index
  end

  # GET /cal_meses/1 or /cal_meses/1.json
  def show
    poblar_cal_mes(@objeto) if @objeto.cal_dias.empty?

    @semanas_mes = @objeto.cal_semanas.order(:cal_semana)

    meses = @objeto.cal_annio.cal_meses.order(:cal_mes)
    @primer_mes = meses.first
    @ultimo_mes = meses.last
    
    @anterior = @objeto.cal_mes == 1 ? nil : meses.find_by(cal_mes: @objeto.cal_mes - 1)
    @siguiente = @objeto.cal_mes == 12 ? nil : meses.find_by(cal_mes: @objeto.cal_mes + 1)

    @h_semanas = {}
    @semanas_mes.each do |semana|
      @h_semanas[semana.cal_semana] = []
      semana.cal_dias.order(:dt_fecha).each do |cal_dia|
        dia = {}
        if cal_dia.cal_mes == @objeto
          dia[:dia] = cal_dia.cal_dia
          dia[:dyf] = cal_dia.dyf? ? 'danger' : 'info'
        end
        # el col_size se ejecuta igual para saber el ancho de la celda en blanco
        dia[:col_size] = ['sábado', 'domingo'].include?(cal_dia.dia_semana) ? '1' : '2'
        @h_semanas[semana.cal_semana] << dia
      end
    end

  end

  # GET /cal_meses/new

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cal_mes
      @objeto = CalMes.find(params[:id])
    end

end
