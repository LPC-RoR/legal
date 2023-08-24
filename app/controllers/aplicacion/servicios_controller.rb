class Aplicacion::ServiciosController < ApplicationController

  include Tarifas

  def aprobacion
    @objeto = TarAprobacion.find(params[:indice])
    init_tabla('tar_facturaciones', @objeto.tar_facturaciones, false)

    sin_asignar = TarFacturacion.where(tar_aprobacion_id: nil, tar_factura_id: nil)
    ids_cliente = sin_asignar.map {|sa| sa.id if sa.padre.cliente.id == @objeto.cliente.id}
    add_tabla('tar_facturaciones', TarFacturacion.where(id: ids_cliente), false)
  end


  private

end
