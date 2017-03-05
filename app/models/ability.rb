class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      can :read, User, id: user.id
      can :read, Tab, user_id: user.id
      can :write, Tab, user_id: user.id
      can :read, Product
      can :write, TabItem
    end
  end
end
