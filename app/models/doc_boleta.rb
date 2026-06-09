class DocBoleta < ApplicationRecord
  belongs_to :doc_honorario
  belongs_to :ownr, polymorphic: true, optional: true

  before_validation :normalizar_emisor_rut

  validates :numero, presence: true
  validates :estado, inclusion: { in: %w[VIGENTE ANULADA] }
  validates :emisor_rut, presence: true
  validates :emisor_nombre, presence: true
  validates :brutos, :retenido, :pagado, numericality: { greater_than_or_equal_to: 0 }

  validates :numero, uniqueness: {
    scope: [:doc_honorario_id, :emisor_rut],
    message: "ya existe una boleta con este número y RUT emisor"
  }

  scope :vigentes, -> { where(estado: 'VIGENTE') }
  scope :anuladas, -> { where(estado: 'ANULADA') }

  def anulada?
    estado == 'ANULADA'
  end

  def vigente?
    estado == 'VIGENTE'
  end

  private

  def normalizar_emisor_rut
    self.emisor_rut = emisor_rut.to_s.gsub('-', '').strip if emisor_rut.present?
  end
end