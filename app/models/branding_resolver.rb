# app/models/branding_resolver.rb
class BrandingResolver
  attr_reader :owner, :context
  
  def initialize(owner, context)
    @owner = owner  # Empresa o Cliente
    @context = context.to_sym
  end
  
  def logo_url
    return nil unless owner.respond_to?(:logo) && owner.logo.attached?
    owner.logo.url
  end

  def footer_html
    resolve_branding(:footer)
  end
  
  def brand_name
    resolve_branding(:razon_social)
  end
  
  def support_email
    resolve_branding(:support_email)
  end
  
  private
  
  def resolve_branding(type)
    case context
    when :investigations, :support
      owner_branding(type) || default_branding(type)
    when :platform
      platform_branding(type) || default_branding(type)
    else
      owner_branding(type) || default_branding(type)
    end
  end
  
  def owner_branding(type)
    return nil unless owner.respond_to?(:logo) # Verifica que implemente Brandeable
    
    case type
    when :logo
      owner.logo&.url
    when :footer
      owner.footer_content&.body&.to_s.presence
    when :name
      owner.brand_name
    when :support_email
      owner.support_email_address
    end
  end
  
  def platform_branding(type)
    config = AppConfiguration.instance
    
    case type
    when :logo
      config.owner_logo&.url
    when :footer
      config.owner_email_footer&.body&.to_s.presence
    when :name
      config.owner_name
    when :support_email
      config.support_email
    end
  end
  
  def default_branding(type)
    case type
    when :logo
      ActionController::Base.helpers.asset_url('laborsafe_logo.png')
    when :footer
      I18n.t('mailers.default_footer', product: 'Laborsafe')
    when :name
      'Laborsafe'
    when :support_email
      'soporte@laborsafe.com'
    end
  end
end