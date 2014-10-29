class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :view
      can :view, [Item, Unit, Vendor, Owner, Comment, Identifier], :department_id => user.department_id
      cannot :manage, [Role, Department, UnitType]

    elsif user.has_role? :admin
      can :manage, [User, Item, Unit, Vendor, Owner, Comment, Identifier], :department_id => user.department_id
      can [:create, :read, :update], [Category, SubCategory, Status]
      can :assign_roles, User, :department_id => user.department_id
      can [:read, :create, :update], [Item, Unit, Vendor, Owner, Comment, Identifier], :department_id => user.department_id
      cannot :manage, [Role, Department, UnitType]
    elsif user.has_role? :manager
      can :manage, [User, Item, Unit, Vendor, Owner, Comment, Identifier], :department_id => user.department_id
      can [:create, :read, :update], [Category, SubCategory, Status]
      cannot :manage, [Role, Department, UnitType]
      cannot :assign_roles, User
    elsif user.has_role? :service
      can [:read, :update], Item, :department_id => user.department_id
      can :manage, [Comment, Identifier], :department_id => user.department_id
      cannot :manage, [Role, Department, UnitType]

    elsif user.has_role? :superuser
      can :manage, :all

    else
      can :read, Item
    end
    if user.paid?
     can :read, :all
     can [:create, :update, :read], [Department, UnitType]
    end
    if user.superuser?
     can :manage, :all
    end
#    can :assign_roles, User, if user.admin?
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
