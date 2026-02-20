# app/models/concerns/brandeable.rb
module Brandeable
  extend ActiveSupport::Concern
  
  def footer_content
    raise NotImplementedError
  end
  
  def brand_name
    raise NotImplementedError
  end
  
  def support_email_address
    raise NotImplementedError
  end
end