class Aplicacion::PublicosController < ApplicationController
  before_action :set_publico, only: %i[ show edit update destroy ]

  # GET /publicos or /publicos.json
  def index
  end

  def home
    if usuario_signed_in?
      # Causas
      csf_ids = Causa.all.map {|causa| causa.id if causa.facturaciones.empty?}.compact
      init_tabla('sin_facturar-causas', Causa.where(id: csf_ids), false)

      add_tabla('en_proceso-causas', Causa.where(estado: 'proceso'), false)
      @causas_en_proceso = Causa.where(estado: 'proceso')

      # Cargos o facturaciones
      add_tabla('sin_aprobacion-tar_facturaciones', TarFacturacion.where(tar_aprobacion_id: nil, tar_factura_id: nil), false)
      add_tabla('sin_facturar-tar_facturaciones', TarFacturacion.where(tar_factura_id: nil), false)

      # Facturas
      add_tabla('por_emitir-tar_facturas', TarFactura.where(estado: 'ingreso').order(fecha_factura: :desc), false)
      add_tabla('en_cobranza-tar_facturas', TarFactura.where(estado: 'facturada').order(fecha_factura: :desc), false)

      # chartkick de facturación
      @facturacion = {
        'ene 2023' => 0,
        'feb 2023' => 0,
        'mar 2023' => 0,
        'abr 2023' => 0,
        'may 2023' => 0,
        'jun 2023' => 0,
        'jul 2023' => 0,
        'ago 2023' => 0,
        'sep 2023' => 0,
        'oct 2023' => 0,
        'nov 2023' => 0,
        'dic 2023' => 0
      }

      facturas = TarFactura.where.not(estado: 'ingreso')
      facturas.each do |factura|
        case factura.fecha_factura.month
        when 1
          @facturacion['ene 2023'] += factura.monto_pesos
        when 2
          @facturacion['feb 2023'] += factura.monto_pesos
        when 3
          @facturacion['mar 2023'] += factura.monto_pesos
        when 4
          @facturacion['abr 2023'] += factura.monto_pesos
        when 5
          @facturacion['may 2023'] += factura.monto_pesos
        when 6
          @facturacion['jun 2023'] += factura.monto_pesos
        when 7
          @facturacion['jul 2023'] += factura.monto_pesos
        when 8
          @facturacion['ago 2023'] += factura.monto_pesos
        when 9
          @facturacion['sep 2023'] += factura.monto_pesos
        when 10
          @facturacion['oct 2023'] += factura.monto_pesos
        when 11
          @facturacion['nov 2023'] += factura.monto_pesos
        when 12
          @facturacion['dic 2023'] += factura.monto_pesos
        end
      end

    else
      articulos = BlgArticulo.all.order(created_at: :desc)
      @principal = articulos.first
      @segundo = articulos.second
      @tercero = articulos.third
    end

#    add_tabla('clientes', Cliente.where(id: TarFacturacion.where(estado: 'ingreso').map {|tarf| tarf.padre.cliente.id unless tarf.tar_factura.present?}.compact.uniq), false)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publico
      @objeto = Publico.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def publico_params
      params.fetch(:publico, {})
    end
end
