# app/policies/application_policy.rb
# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # --------- 1.  DEFAULTS para CRUD (opcional pero cómodo) ---------
  def index?
    same_tenant?
  end

  def show?
    same_tenant?
  end

  def create?
    same_tenant?
  end

  def new?
    create?
  end

  def update?
    same_tenant?
  end

  def edit?
    update?
  end

  def destroy?
    same_tenant?
  end

  # --------- 2.  SCOPES (obligatorio) ---------
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.where(tenant: user.tenant)
    end

    private

    attr_reader :user, :scope
  end

  private

  # el registro debe pertenecer al mismo tenant que el usuario
  def same_tenant?
    user.tenant == record.tenant
  end
end