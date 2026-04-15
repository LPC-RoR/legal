# app/policies/app_nomina_policy.rb
class AppNominaPolicy < ApplicationPolicy
  def index?
    user.has_role?(:admin) || user.has_role?(:dog)
  end

  def show?
    user.has_role?(:admin) || user.has_role?(:dog) || record.ownr == user
  end

  def create?
    user.has_role?(:admin) || user.has_role?(:dog)
  end

  def update?
    user.has_role?(:admin) || user.has_role?(:dog) || record.ownr == user
  end

  def destroy?
    user.has_role?(:admin) || user.has_role?(:dog)
  end

  def verify?
    true # Cualquiera puede verificar con el token
  end

  def resend_welcome_email?
    user.has_role?(:admin) || user.has_role?(:dog)
  end

  class Scope < Scope
    def resolve
      if user.has_role?(:dog)
        scope.all
      elsif user.has_role?(:admin)
        scope.where(ownr: user.tenant)
      else
        scope.where(ownr: user)
      end
    end
  end
end