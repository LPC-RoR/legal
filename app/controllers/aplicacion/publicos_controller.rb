class Aplicacion::PublicosController < ApplicationController
  before_action :set_publico, only: %i[ show edit update destroy ]
  before_action :inicia_sesion, only: [:home]

  # GET /publicos or /publicos.json
  def index
  end

  def home
    if usuario_signed_in?
      inicia_sesion if perfil_activo.blank?
      if operacion?
        # Causas
        set_tabla('tramitacion-causas', Causa.where(estado: 'tramitación'), false)
        @causas_en_proceso = Causa.where(estado: 'tramitación')
      end

      if finanzas?
        # Causas
        csf_ids = Causa.all.map {|causa| causa.id if causa.facturaciones.empty?}.compact
        set_tabla('sin_facturar-causas', Causa.where(id: csf_ids), false)

        # Cargos o facturaciones
        set_tabla('sin_aprobacion-tar_facturaciones', TarFacturacion.where(tar_aprobacion_id: nil, tar_factura_id: nil), false)
        set_tabla('sin_facturar-tar_facturaciones', TarFacturacion.where(tar_factura_id: nil).where.not(tar_aprobacion_id: nil), false)

        # Facturas
        set_tabla('por_emitir-tar_facturas', TarFactura.where(estado: 'ingreso').order(fecha_factura: :desc), false)
        set_tabla('en_cobranza-tar_facturas', TarFactura.where(estado: 'facturada').order(fecha_factura: :desc), false)

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
            @facturacion['ene 2023'] += factura.monto_corregido
          when 2
            @facturacion['feb 2023'] += factura.monto_corregido
          when 3
            @facturacion['mar 2023'] += factura.monto_corregido
          when 4
            @facturacion['abr 2023'] += factura.monto_corregido
          when 5
            @facturacion['may 2023'] += factura.monto_corregido
          when 6
            @facturacion['jun 2023'] += factura.monto_corregido
          when 7
            @facturacion['jul 2023'] += factura.monto_corregido
          when 8
            @facturacion['ago 2023'] += factura.monto_corregido
          when 9
            @facturacion['sep 2023'] += factura.monto_corregido
          when 10
            @facturacion['oct 2023'] += factura.monto_corregido
          when 11
            @facturacion['nov 2023'] += factura.monto_corregido
          when 12
            @facturacion['dic 2023'] += factura.monto_corregido
          end
        end
      end

    else
      articulos = BlgArticulo.all.order(created_at: :desc)
      @principal = articulos.first
      @segundo = articulos.second
      @tercero = articulos.third
    end

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
