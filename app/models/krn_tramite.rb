class KrnTramite < ApplicationRecord
  include ConditionalArray

  belongs_to :krn_denuncia

  DSPLY_CDGS = {
    dnnc: [
      { code: 'derivacion_denuncia_dt',     condition: ->(o) { o.dnncnt_optn_invstgcn == 'Dirección del Trabajo' || (o.dnncnt_optn_invstgcn == 'Empresa' && o.emprs_optn_invstgcn == 'Dirección del Trabajo') } },
      { code: 'aviso_inicio_investigacion', condition: ->(o) { o.dnncnt_optn_invstgcn == 'Empresa' && o.emprs_optn_invstgcn == 'Empresa' } },
      { code: 'deposito_investigacion',     condition: ->(o) { o.etapa == 'etp_infrm' } },
    ]
  }

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
  scope :deposito_investigacion,      -> { find_by(tipo: 'deposito_investigacion') }
  scope :aviso_inicio_investigacion,  -> { find_by(tipo: 'aviso_inicio_investigacion') }
  scope :derivacion_denuncia_dt,      -> { find_by(tipo: 'derivacion_denuncia_dt') }

  def self.nombre
    {
      'derivacion_denuncia_dt'      => 'Derivación de denuncia a la Dirección del Trabajo',
      'aviso_inicio_investigacion'  => 'Aviso de inico de investigación a la Dirección del Trabajo',
      'deposito_investigacion'      => 'Depósito del informe de investigación'
    }    
  end

  def self.dsply_codes_for(ownr)
    items = DSPLY_CDGS[ownr.kywrd[:sym]] || []
    available_codes_for(ownr, items)
  end

  def fecha_tramite
    fecha_hora.to_date
  end
end
