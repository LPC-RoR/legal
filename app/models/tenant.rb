class Tenant < ApplicationRecord
  resourcify   # <= permite roles sobre tenants

  belongs_to :owner, polymorphic: true
  has_many :usuarios, dependent: :destroy
  # has_many :krn_denuncias, dependent: :destroy

  def self.current=(tenant)
    RequestStore.store[:tenant] = tenant
  end

  def self.current
    RequestStore.store[:tenant]
  end

  # helper para la UI
  def display_name
    "#{owner.class.model_name.human}: #{owner.try(:nombre) || owner.try(:razon_social)}"
  end

end