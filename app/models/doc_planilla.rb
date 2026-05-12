class DocPlanilla < ApplicationRecord
  has_many :doc_emitidos, dependent: :nullify

  has_one_attached :archivo

  enum :tipo, {
    emitidos: 'emitidos',
    recibidos: 'recibidos'
  }, prefix: true, default: 'emitidos'

	enum :estado, {
	  pendiente: 'pendiente',
	  procesando: 'procesando',
	  completado: 'completado',
	  error: 'error'
	}, default: 'pendiente'

  validates :mes, presence: true, inclusion: { in: 1..12 }
  validates :anio, presence: true, numericality: { greater_than: 2000 }
  validates :archivo, presence: true
  validates :nombre_original, presence: true

  scope :por_periodo, ->(anio, mes) { where(anio: anio, mes: mes) }
  scope :completadas, -> { where(estado: 'completado') }
  scope :con_error, -> { where(estado: 'error') }

  def periodo
    "#{mes.to_s.rjust(2, '0')}/#{anio}"
  end

  def progreso
    return 0 if total_documentos.zero?
    ((documentos_cargados.to_f / total_documentos) * 100).round
  end
end
