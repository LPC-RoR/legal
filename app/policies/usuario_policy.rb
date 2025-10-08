class UsuarioPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index_global?
    user.has_role?(:dog)
  end

  def index_tenant?
    return true if user.has_role?(:admin) || user.has_role?(:dog)
    tenant = record.first&.tenant || Tenant.current
    user.has_role?(:admin, tenant)
  end

  # ✅ Cambiar rol a UN usuario
  def update_role?
    return true if user.has_role?(:admin) || user.has_role?(:dog)   # admin global
    return false if record.global?                                  # no toco globales

    user.has_role?(:admin, record.tenant)                           # admin del tenant
  end
end