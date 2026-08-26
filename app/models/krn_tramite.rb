class KrnTramite < ApplicationRecord
  include ConditionalArray

  belongs_to :krn_denuncia

  DSPLY_CDGS = {
    dnnc: [
      { code: 'derivacion_denuncia_externa',  condition: ->(o) { o.rcp_empresa? && o.externa? } },
      { code: 'derivacion_denuncia_empresa',  condition: ->(o) { o.rcp_externa? && !o.externa? } },
      { code: 'derivacion_denuncia_dt',       condition: ->(o) { o.dnncnt_optn_invstgcn == 'Dirección del Trabajo' || (o.dnncnt_optn_invstgcn == 'Empresa' && o.emprs_optn_invstgcn == 'Dirección del Trabajo') } },
      { code: 'aviso_inicio_investigacion',   condition: ->(o) { o.dnncnt_optn_invstgcn == 'Empresa' && o.emprs_optn_invstgcn == 'Empresa' } },
      { code: 'deposito_investigacion',       condition: ->(o) { o.etapa != 'etp_rcpcn' } },
    ]
  }

  TIPOS = %w[
    derivacion_denuncia_externa
    derivacion_denuncia_empresa
    deposito_investigacion
    aviso_inicio_investigacion
    derivacion_denuncia_dt
  ].freeze

  validates :tipo, presence: true, inclusion: { in: TIPOS }
  validates :numero_solicitud, presence: true, uniqueness: true
  validates :fecha_hora, presence: true
  validates :tipo, uniqueness: { scope: :krn_denuncia_id, message: 'ya existe para esta denuncia' }

  # Scopes de conveniencia
  scope :derivacion_denuncia_externa, -> { where(tipo: 'derivacion_denuncia_externa') }
  scope :derivacion_denuncia_empresa, -> { where(tipo: 'derivacion_denuncia_empresa') }
  scope :deposito_investigacion,      -> { where(tipo: 'deposito_investigacion') }
  scope :aviso_inicio_investigacion,  -> { where(tipo: 'aviso_inicio_investigacion') }
  scope :derivacion_denuncia_dt,      -> { where(tipo: 'derivacion_denuncia_dt') }

  def self.nombre
    {
      'derivacion_denuncia_externa' => 'Derivación a una empresa externa',
      'derivacion_denuncia_empresa' => 'Derivación desde una empresa externa',
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
