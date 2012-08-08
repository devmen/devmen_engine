class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new # guest user
    
    if user.role? :admin
      can :manage, :all
    elsif user.role? :manager      
      can :manage, Page      
      can [:read, :update], User do |u|
        u == user
      end
    else
      can :read, :all      
    end
  end
end
