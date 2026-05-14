# app/models/doc_emitido.rb
class DocEmitido < ApplicationRecord
  belongs_to :doc_planilla, optional: true
  belongs_to :cliente, optional: true

  has_many :doc_detalles

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

  TIPOS_FACTURA = %w[asesoria cargo causa varios].freeze

  validates :tipo_dte, presence: true, inclusion: { in: TIPOS_DTE.keys }
  validates :folio, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :fecha_emision, presence: true
  validates :rut_emisor, presence: true
  validates :razon_social_emisor, presence: true
  validates :rut_receptor, presence: true
  validates :razon_social_receptor, presence: true
  validates :tipo_factura, inclusion: { in: TIPOS_FACTURA, allow_blank: true }

  validates :folio, uniqueness: { scope: [:tipo_dte, :rut_emisor] }

  scope :por_tipo_factura, ->(tipo) { where(tipo_factura: tipo) }
  scope :sin_tipo_factura, -> { where(tipo_factura: nil) }

  scope :facturas, -> { where(tipo_dte: [33, 34, 56]) }
  scope :creditos, -> { where(tipo_dte: [61] )}

  def tipo_dte_nombre
    TIPOS_DTE[tipo_dte] || 'Desconocido'
  end

  def tipo_factura_nombre
    return 'Sin clasificar' if tipo_factura.blank?
    tipo_factura.capitalize
  end

  def monto_total
    total_monto_total || total_exento || total_neto || 0
  end
end