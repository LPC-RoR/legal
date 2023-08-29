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

      add_tabla('en_proceso-causas', Causa.where(estado: 'fijo'), false)
      @causas_en_proceso = Causa.where(estado: 'fijo')

      # Cargos o facturaciones
      add_tabla('sin_aprobacion-tar_facturaciones', TarFacturacion.where(tar_aprobacion_id: nil), false)
      add_tabla('sin_facturar-tar_facturaciones', TarFacturacion.where(tar_factura_id: nil), false)

      # Facturas
      add_tabla('por_emitir-tar_facturas', TarFactura.where(estado: 'ingreso').order(fecha_factura: :desc), false)
      add_tabla('en_cobranza-tar_facturas', TarFactura.where(estado: 'facturada').order(fecha_factura: :desc), false)
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
