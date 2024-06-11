class Organizacion::ServiciosController < ApplicationController

  include Tarifas

  def aprobacion
    @objeto = TarAprobacion.find(params[:indice])
    set_tabla('tar_facturaciones', @objeto.tar_facturaciones, false)
    set_tabla('tar_calculos', @objeto.tar_calculos, false)

    @total_uf = @objeto.tar_calculos.map {|ccl| monto_uf(ccl, ccl.owner, ccl.tar_pago)}.sum
    @total_pesos = @objeto.tar_calculos.map {|ccl| monto_pesos(ccl, ccl.owner, ccl.tar_pago)}.sum

    @h_pagos = get_h_pagos(@objeto)

    @coleccion['tar_facturaciones'].each do |tar_facturacion|
        set_detalle_cuantia(tar_facturacion.owner, porcentaje_cuantia: tar_facturacion.porcentaje_cuantia?) if tar_facturacion.owner.class.name == 'Causa'
    end

  end

  def antecedentes
    @objeto = Causa.find(params[:cid])
  end

  def organizacion
    unless params[:oid].blank?
      @objeto = Cliente.find(params[:oid])
      set_tabla('org_areas', @objeto.org_areas.order(:org_area), false)
      set_tabla('org_regiones', @objeto.org_regiones.order(:orden), false)
    end
  end

  def sucursales
    @objeto = OrgSucursal.find(params[:sid])

    set_tabla('org_empleados', @objeto.org_empleados.order(:apellido_paterno), false)
  end

  def empleados
    @objeto = OrgEmpleado.find(params[:eid])

#    set_tabla('org_empleados', @objeto.org_empleados.order(:apellido_paterno), false)
  end

  private

  # crea el array con el cálculo del pago
    def array_pago(tar_facturacion)
      {
        pago: tar_facturacion,
        origen_fecha_pago: tar_facturacion.origen_fecha_uf,
        monto_pesos: tar_facturacion.monto_pesos,
        monto_uf: tar_facturacion.monto_uf
      }
    end

    # crea un hash con el cálculo de los pagos
    def get_h_pagos(aprobacion)
      h_pagos = {}      
      aprobacion.tar_facturaciones.each do |tar_facturacion|
        h_pagos[tar_facturacion.id] = array_pago(tar_facturacion)
      end
      h_pagos
    end

end
