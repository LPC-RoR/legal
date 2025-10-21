# app/policies/act_archivo_policy.rb
class ActArchivoPolicy < ApplicationPolicy
  def download?
    true          # change to whatever logic you need
  end
end