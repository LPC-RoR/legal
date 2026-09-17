# app/models/doc_emitido.rb
class DocEmitido < ApplicationRecord
  belongs_to :doc_planilla, optional: true
  belongs_to :cliente, optional: true

  # Conciliacion de Aprobaciones
  belongs_to :cli_aprobacion, optional: true

  # La NC que anula a este documento (solo aplica cuando estado = anulada)
  belongs_to :nota_credito, class_name: "DocEmitido", optional: true

  # Documento que esta NC anuló (sentido inverso)
  has_one :documento_anulado,
          class_name: "DocEmitido",
          foreign_key: "nota_credito_id",
          dependent: :nullify,
          inverse_of: :nota_credito


  has_many :doc_detalles
  has_many :doc_pagos, as: :ownr

  include AASM

  enum :estado, {
    emitida: 0,
    pagada:  1,
    anulada: 2
  }, prefix: true

  aasm column: :estado, enum: true do
    state :emitida, initial: true
    state :pagada
    state :anulada

    event :marcar_pagada do
      transitions from: :emitida, to: :pagada
    end

    event :anular, before: :copiar_folio_nota_credito do
      transitions from: [:emitida, :pagada], to: :anulada
    end
  end

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

  validates :nota_credito, presence: true, if: :estado_anulada?
  validate :nota_credito_debe_ser_tipo_distinto, if: -> { nota_credito.present? }
  validate :no_autorreferencia, if: -> { nota_credito_id.present? }

  validates :folio, uniqueness: { scope: [:tipo_dte, :rut_emisor] }

  scope :por_tipo_factura, ->(tipo) { where(tipo_factura: tipo) }
  scope :sin_tipo_factura, -> { where(tipo_factura: nil) }

  scope :facturas, -> { where(tipo_dte: [33, 34, 56]) }
  scope :creditos, -> { where(tipo_dte: [61] )}

  scope :entre_fechas, ->(fecha_inicial, fecha_termino) {
    where(fecha_emision: fecha_inicial..fecha_termino)
      .order(fecha_emision: :asc, id: :asc)
  }

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

  def monto_sumable
    tipo_dte == 61 ? -monto_total : monto_total
  end

  private

  def estado_anulada?
    estado == "anulada"
  end

  def copiar_folio_nota_credito
    self.nota_credito_folio = nota_credito&.folio if estado == "anulada"
  end

  def nota_credito_debe_ser_tipo_distinto
    if nota_credito.tipo_dte == tipo_dte
      errors.add(:nota_credito, "debe tener un tipo_dte distinto al documento anulado")
    end
  end

  def no_autorreferencia
    errors.add(:nota_credito, "no puede ser el mismo documento") if nota_credito_id == id
  end
end