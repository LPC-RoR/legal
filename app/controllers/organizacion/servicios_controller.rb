class Organizacion::ServiciosController < ApplicationController

  include Tarifas

  def aprobacion
    @objeto = TarAprobacion.find(params[:indice])
    init_tabla('tar_facturaciones', @objeto.tar_facturaciones, false)
  end

  def organizacion
    unless params[:oid].blank?
      @objeto = Cliente.find(params[:oid])
      init_tabla('org_areas', @objeto.org_areas.order(:org_area), false)
      add_tabla('org_regiones', @objeto.org_regiones.order(:orden), false)
    end
  end

  def sucursales
    @objeto = OrgSucursal.find(params[:sid])

    init_tabla('org_empleados', @objeto.org_empleados.order(:apellido_paterno), false)
  end

  def empleados
    @objeto = OrgEmpleado.find(params[:eid])

#    init_tabla('org_empleados', @objeto.org_empleados.order(:apellido_paterno), false)
  end

  private

end
