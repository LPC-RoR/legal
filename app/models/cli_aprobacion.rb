# app/models/cli_aprobacion.rb
class CliAprobacion < ApplicationRecord
  belongs_to :cliente

  has_many :tar_facturaciones, dependent: :nullify
  has_many :act_archivos, as: :ownr, dependent: :destroy

  # Conciliación con facturas cargadas
  has_many :doc_emitidos, dependent: :nullify

  include AASM

  enum :estado, {
    emitida:   0,
    enviada:   1,
    aprobada:  2,
    facturada: 3
  }, prefix: true

  aasm column: :estado, enum: true do
    state :emitida, initial: true
    state :enviada
    state :aprobada
    state :facturada

    event :enviar do
      transitions from: :emitida, to: :enviada
    end

    event :aprobar do
      transitions from: :enviada, to: :aprobada
    end

    event :marcar_facturada do
      transitions from: :aprobada, to: :facturada
    end

    # Permitir reprocesos sin perder trazabilidad
    event :reabrir do
      transitions from: :enviada, to: :emitida
    end
  end

  validates :fecha, presence: true
#  validates :cliente_id, uniqueness: { scope: :fecha, message: "ya tiene una aprobación para esta fecha" }

  after_create :asociar_facturaciones_pendientes

  def excluir_facturacion(tar_facturacion)
    tar_facturacion.update!(cli_aprobacion_id: nil)
  end

  private

  def asociar_facturaciones_pendientes
    
    # Actualiza las tar_facturaciones pendientes de esos cálculos
    cliente.tar_facturaciones_pendientes_aprobacion.update_all(cli_aprobacion_id: id)
  end
end