# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      can :read, User, id: user.id
      can :read, Tab, user_id: user.id
      can :read, Product
      can :read, Bill
      can :download, Bill, user: user
      can :write, Tab do |tab|
        user.tab_manager? && tab.user_id == user.id
      end
      can :write, User, id: user.id
      can :write, TabItem do |tab_item|
        user.tab_manager? && tab_item.cart.user_id == user.id
      end
      can :write, Cart do |cart|
        user.tab_manager? && cart.user_id == user.id
      end
    end
  end
end
