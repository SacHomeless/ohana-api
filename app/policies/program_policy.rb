class ProgramPolicy < ApplicationPolicy
  def new?
    Pundit.policy_scope!(user, Organization).present?
  end

  class Scope < Scope
    def resolve
      return scope.order(:name) if user.super_admin?
      scope.with_orgs(org_ids)
    end

    def org_ids
      Pundit.policy_scope!(user, Organization).map(&:id).flatten
    end
  end
end
