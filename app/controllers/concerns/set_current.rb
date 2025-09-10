# app/controllers/concerns/set_current.rb
module SetCurrent
  extend ActiveSupport::Concern

  included do
    before_action :set_current_tenant
  end

  private

  def set_current_tenant
    Current.tenant = current_usuario&.tenant # or whatever logic you use
  end
end

class ApplicationController < ActionController::Base
  include SetCurrent
end