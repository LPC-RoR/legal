class Tenant < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_many :usuarios, dependent: :destroy
  # más adelante: has_many :krn_denuncias, ...

  def self.current=(tenant)
    RequestStore.store[:tenant] = tenant
  end

  def self.current
    RequestStore.store[:tenant]
  end
end
