# app/models/current.rb
require "active_support/current_attributes"   # opcional, pero no daña

class Current < ActiveSupport::CurrentAttributes
  attribute :tenant
  attribute :user
end