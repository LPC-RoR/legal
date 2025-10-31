class Usuario < ApplicationRecord
  rolify strict: true
  belongs_to :tenant, optional: false   # todos los usuarios SIEMPRE van a un tenant
  has_many :rcrs_enlaces, as: :ownr
  has_many :notas

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, 
         :lockable, :timeoutable, :confirmable

  delegate :owner, to: :tenant, allow_nil: true   # Company/Client o nil

  ROLES = %i[dog admin general auditor operacion finanzas recepcion investigador].freeze
  ADDT_ROLES = %i[dog admin general operacion finanzas].freeze
  LBSF_ROLES = %i[admin auditor recepcion investigador].freeze

#  validate :role_must_be_in_list

  def role_must_be_in_list
    errors.add(:role, 'no es válido') unless ROLES.include?(role)
  end

  scope :ordered, -> { order(:created_at) }

  def surname
    nombre || email.split('@')[0].split('.')[0].upcase
  end

  def global?
    tenant_id.nil?
  end

  def role=(new_role)
    if global?
      roles.destroy_all
      add_role(new_role)
    else
      roles.where(resource: tenant).destroy_all   # <= forma correcta
      add_role(new_role, tenant)
    end
  end

  def role
    global? ? roles.first&.name : roles.where(resource: tenant).first&.name
  end

  def dog?
    has_role?(:dog) or has_role?(:dog, tenant)
  end

  def rl_admin?
    has_role?(:admin) or has_role?(:admin, tenant)
  end

  def rl_general?
    has_role?(:general)
  end

  def rl_auditor?
    has_role?(:auditor, tenant)
  end

  def rl_operacion?
    has_role?(:operacion) or has_role?(:operacion, tenant)
  end

  def rl_finanzas?
    has_role?(:finanzas)
  end

  def rl_recepcion?
    has_role?(:recepcion, tenant)
  end

  def rl_investigador?
    has_role?(:investigador, tenant)
  end

  def admin?
    dog? || rl_admin?
  end

  def auditor?
    dog? || rl_auditor? || rl_operacion?
  end

  def operacion?
    dog? || rl_admin? || rl_general? || rl_operacion?
  end

  def finanzas?
    dog? || rl_admin? || rl_general? || rl_finanzas?
  end

  def recepcion?
    dog? || rl_admin? || rl_recepcion? || rl_operacion?
  end

  def investigador?
    dog? || rl_admin? || rl_investigador? || rl_operacion?
  end

end
