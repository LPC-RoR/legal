class KrnTramite < ApplicationRecord
  belongs_to :krn_denuncia

  TIPOS = %w[
    deposito_investigacion
    aviso_inicio_investigacion
    derivacion_denuncia_dt
  ].freeze

  validates :tipo, presence: true, inclusion: { in: TIPOS }
  validates :numero_solicitud, presence: true, uniqueness: true
  validates :fecha_hora, presence: true
  validates :tipo, uniqueness: { scope: :krn_denuncia_id, message: 'ya existe para esta denuncia' }

  # Scopes de conveniencia
  scope :deposito_investigacion, -> { find_by(tipo: 'deposito_investigacion') }
  scope :aviso_inicio_investigacion, -> { find_by(tipo: 'aviso_inicio_investigacion') }
  scope :derivacion_denuncia_dt, -> { find_by(tipo: 'derivacion_denuncia_dt') }

  def fecha_tramite
    fecha_hora.to_date
  end
end
