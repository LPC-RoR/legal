class DocEmitido < ApplicationRecord
  belongs_to :doc_planilla, optional: true
  belongs_to :cliente, optional: true

  TIPOS_DTE = {
    33 => 'Factura Electrónica',
    34 => 'Factura Exenta Electrónica',
    46 => 'Factura de Compra Electrónica',
    52 => 'Guía de Despacho Electrónica',
    56 => 'Nota de Débito Electrónica',
    61 => 'Nota de Crédito Electrónica'
  }.freeze

  FORMAS_PAGO = {
    1 => 'Contado',
    2 => 'Crédito',
    3 => 'Gratuito'
  }.freeze

  validates :tipo_dte, presence: true, inclusion: { in: TIPOS_DTE.keys }
  validates :folio, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :fecha_emision, presence: true
  validates :rut_emisor, presence: true
  validates :razon_social_emisor, presence: true
  validates :rut_receptor, presence: true
  validates :razon_social_receptor, presence: true

  validates :folio, uniqueness: { scope: [:tipo_dte, :rut_emisor] }

  scope :por_periodo, ->(anio, mes) {
    where(fecha_emision: Date.new(anio, mes, 1)..Date.new(anio, mes, -1))
  }
  scope :por_receptor, ->(rut) { where(rut_receptor: rut) }
  scope :por_tipo, ->(tipo) { where(tipo_dte: tipo) }
  scope :por_fecha, ->(desde, hasta) { where(fecha_emision: desde..hasta) }
  scope :sin_cliente, -> { where(cliente_id: nil) }
  scope :con_cliente, -> { where.not(cliente_id: nil) }

  scope :facturas, -> { where(tipo_dte: [33, 34, 56]) }
  scope :creditos, -> { where(tipo_dte: [61]) }

  def tipo_dte_nombre
    TIPOS_DTE[tipo_dte] || 'Desconocido'
  end

  def forma_pago_nombre
    FORMAS_PAGO[forma_pago] || 'No especificada'
  end

  def monto_total
    total_monto_total || total_exento || total_neto || 0
  end
end