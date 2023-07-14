class Aplicacion::PublicosController < ApplicationController
  before_action :set_publico, only: %i[ show edit update destroy ]

  # GET /publicos or /publicos.json
  def index
  end

  def home
    if usuario_signed_in?
      # Causas
      csc_ids = Causa.all.map {|causa| causa.id if causa.valores_cuantia.empty?}.compact
      @causas_sin_cuantia = Causa.where(id: csc_ids)

      csf_ids = Causa.all.map {|causa| causa.id if causa.facturaciones.empty?}.compact
      @causas_sin_facturar = Causa.where(id: csf_ids)

      @causas_en_proceso = Causa.where(estado: 'fijo')

      # Cargos o facturaciones
      @cargos_sin_aprobar = TarFacturacion.where(tar_factura_id: nil).where.not(estado: 'aprobado')
      @cargos_sin_facturar = TarFacturacion.where(tar_factura_id: nil, estado: 'aprobado')

      # Facturas
      @facturas_sin_emitir = TarFactura.where(estado: 'ingreso').order(fecha_factura: :desc)
      @facturas_en_cobranza = TarFactura.where(estado: 'facturada').order(fecha_factura: :desc)
    end

    init_tabla('clientes', Cliente.where(id: TarFacturacion.where(estado: 'ingreso').map {|tarf| tarf.padre.cliente.id unless tarf.tar_factura.present?}.compact.uniq), false)
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
