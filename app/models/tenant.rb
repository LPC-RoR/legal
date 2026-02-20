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

  # Manejo de logos y Footers

  # Nuevo método - no toca nada existente
  def branding_for(context)
    BrandingResolver.new(owner, context)
  end
  
  # Helper para saber si el owner implementa branding completo
  def brandeable?
    owner.respond_to?(:logo)  # Verifica que tenga el attachment de Active Storage
  end

  # Método directo para el logo, sin intermediarios
  def logo_url
    owner.logo.url if owner.respond_to?(:logo) && owner.logo.attached?
  end

end