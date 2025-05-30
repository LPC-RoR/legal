class Organizacion::ServiciosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on

  include Tarifas

  def aprobacion
    @indice = params[:indice]
    @objeto = TarAprobacion.find(params[:indice])
    set_tabla('tar_facturaciones', @objeto.tar_facturaciones, false)
    set_tabla('tar_calculos', @objeto.tar_calculos, false)

    @total_uf = @objeto.tar_calculos.map {|ccl| get_monto_calculo_uf(ccl, ccl.ownr, ccl.tar_pago)}.sum
    @total_pesos = @objeto.tar_calculos.map {|ccl| get_monto_calculo_pesos(ccl, ccl.ownr, ccl.tar_pago)}.sum

    @h_pagos = get_h_pagos(@objeto)
  
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "aprobacion_#{@indice}",
               template: "organizacion/servicios/aprobacion.html.erb",
               layout: 'pdf.html.erb'
      end
    end
  rescue ArgumentError => e
    # Manejar errores de parámetros inválidos
    redirect_to "/servicios/aprobacion", alert: "Invalid date format. Please use YYYY-MM-DD."
  end

  def documentos
    @objeto = LglDocumento.find_by(codigo: params[:cdg])
    set_tabla('lgl_parrafos', @objeto.lgl_parrafos.ordr, false)
  end

  def auditoria
    @objeto = Cliente.find(params[:oid])
    @annio = (Time.zone.today.year-1).to_s

#    causas = @objeto.causas.where("rit LIKE ?", "%#{@annio}").std('tramitación')
#    causas = @objeto.causas.std('tramitación')
    causas = @objeto.causas.where.not(Causa.arel_table[:rit].matches_any(["C%", "J%"])).std('tramitación')

    set_tabla('causas', causas, false)
  end

  def adncs
      set_tabla('age_actividades', AgeActividad.where('fecha > ?', Time.zone.today.beginning_of_day).adncs.fecha_ordr, false)
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

  def multas
    @objt = DtMateria.find(params[:oid])
    set_tabla('dt_infracciones', @objt.dt_infracciones.order(:codigo), false)
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
