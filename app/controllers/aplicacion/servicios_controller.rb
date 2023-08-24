class Aplicacion::ServiciosController < ApplicationController

  include Tarifas

  def aprobacion
    @objeto = TarAprobacion.find(params[:indice])
    init_tabla('tar_facturaciones', @objeto.tar_facturaciones, false)

  end


  private

end
