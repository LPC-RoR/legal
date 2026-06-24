# app/models/cli_aprobacion.rb
class CliAprobacion < ApplicationRecord
  belongs_to :cliente

  has_many :tar_facturaciones, dependent: :nullify

  validates :fecha, presence: true
  validates :cliente_id, uniqueness: { scope: :fecha, message: "ya tiene una aprobación para esta fecha" }

  after_create :asociar_facturaciones_pendientes

  def excluir_facturacion(tar_facturacion)
    tar_facturacion.update!(cli_aprobacion_id: nil)
  end

  private

  def asociar_facturaciones_pendientes
    # Obtiene los IDs de causas del cliente
    causas_ids = Causa.where(cliente_id: cliente_id).pluck(:id)
    
    # Obtiene los IDs de tar_calculos donde ownr es una Causa del cliente
    calculos_ids = TarCalculo
      .where(ownr_type: 'Causa', ownr_id: causas_ids)
      .pluck(:id)
    
    # Actualiza las tar_facturaciones pendientes de esos cálculos
    TarFacturacion
      .where(cli_aprobacion_id: nil)
      .where(tar_calculo_id: calculos_ids)
      .update_all(cli_aprobacion_id: id)
  end
end