# app/policies/menu_policy.rb
class MenuPolicy < ApplicationPolicy
  def show?                                     # <- sin parámetros
    return false unless user
    return false unless record.enabled?

    case record.key
    when 'admin' then user.admin?
    else
      false
    end
  end
end