class DocCartola < ApplicationRecord
  TIPOS = %w[provisoria mensual].freeze

  belongs_to :doc_cuenta, optional: true
  has_many :doc_transacciones, dependent: :destroy
  has_one_attached :archivo

  scope :mensuales,   -> { where(tipo: 'mensual') }
  scope :provisorias, -> { where(tipo: 'provisoria') }

  def mensual?    = tipo == 'mensual'
  def provisoria? = !mensual?

  # Movimientos con signo: abonos ('A') suman, cargos ('C' o cualquier otro valor) restan
  def total_movimientos
    abonos = doc_transacciones.where(tipo_movimiento: 'A').sum(:monto)
    cargos = doc_transacciones.where.not(tipo_movimiento: 'A').sum(:monto)
    (abonos - cargos).round(2)
  end

  # Cuadratura: saldo_inicial + movimientos debe dar saldo_final
  def diferencia_cuadratura
    return nil if saldo_inicial.nil? || saldo_final.nil?
    (saldo_inicial + total_movimientos - saldo_final).round(2)
  end

  def cuadrada?(tolerancia = 0.01)
    d = diferencia_cuadratura
    d && d.abs <= tolerancia
  end
end