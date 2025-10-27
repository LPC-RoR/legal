# app/models/licencia.rb
class Licencia < ApplicationRecord
  belongs_to :empresa
  has_many   :krn_denuncias, through: :empresa

  scope :active, -> { where(status: 'active') }
  scope :expired, -> { where(status: 'expired') }

  validate  :no_superar_limite, on: :create, if: -> { plan == 'demo' }
  before_create :set_default_fechas

  MAX_DEMO_RENEWS = 1   # 1 vez, cámbialo si quieres más

  def puede_renovar_demo?
    plan == 'demo' && demo_renews < MAX_DEMO_RENEWS
  end

  def renovar_demo!
    raise 'No se puede renovar esta demo' unless puede_renovar_demo?
    update!(
      finished_at: finished_at + 10.days,
      demo_renews: demo_renews + 1
    )
  end

  # ---- negocio ----
  def tope_alcanzado?
    denuncias_usadas >= max_denuncias
  end

  def expirada?
    finished_at.past?
  end

  # demo → anual
  def activar_compra!
    raise 'Solo demo puede convertirse' unless plan == 'demo'
    update!(
      plan:            'anual',
      max_denuncias:   20,
      started_at:      Time.current,
      finished_at:     1.year.from_now
    )
  end

  # renovar
  def renovar!
    raise 'Solo anual puede renovarse' unless plan == 'anual'
    update!(
      started_at:  Time.current,
      finished_at: 1.year.from_now,
      denuncias_usadas: 0
    )
  end

  # cron diario
  def self.marcar_expiradas!
    active.where('finished_at < ?', Time.current).update_all(status: 'expired')
  end

  # app/models/licencia.rb
  def denuncias_usadas
    empresa.krn_denuncias.count
  end

  private

  def set_default_fechas
    self.started_at  ||= Time.current
    self.finished_at ||= (plan == 'demo' ? 10.days.from_now : 1.year.from_now)
    self.status      ||= 'active'
    self.denuncias_usadas ||= 0
  end

  def no_superar_limite
    errors.add(:base, 'Ya existe una demo activa') if empresa.licencias.active.exists?
  end
end