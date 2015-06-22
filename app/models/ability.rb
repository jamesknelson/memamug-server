class Ability
  include CanCan::Ability

  def initialize(user)
    # Default to guest user
    user ||= User.new

    # Anybody can manage their own account
    can :manage, User, id: user.id
    can :manage, Photo, user_id: user.id
    can :manage, Contact, user_id: user.id
  end
end
