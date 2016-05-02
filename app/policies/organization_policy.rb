class OrganizationPolicy < ApplicationPolicy
  def new?
    user.super_admin?
  end

  class Scope < Scope
    def resolve
      return scope.order(:name) if user.super_admin?
      scope.with_locations(location_ids)
    end
  end
end
