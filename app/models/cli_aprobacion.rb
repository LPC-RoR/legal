# app/models/cli_aprobacion.rb
class CliAprobacion < ApplicationRecord
  belongs_to :cliente

  has_many :tar_facturaciones, dependent: :nullify
  has_many :act_archivos, as: :ownr, dependent: :destroy

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