class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, [User, Item, Unit, Vendor, Owner, Comment, Identifier, Group, Checkout, Cloth], :department_id => user.department_id
#      can :manage, [User, Item, Unit, Vendor, Owner, Comment, Identifier, Group, Checkout, CheckoutItems], :department_id => user.department_id
      can [:create, :read, :update], [Category, SubCategory, Status]
      can :assign_roles, User, :department_id => user.department_id
      can [:read, :create, :update], [Item, Unit, Vendor, Owner, Comment, Identifier], :department_id => user.department_id
      can :last_seen, Item
      cannot :manage, [Role, Department, UnitType]
    end

    if user.has_role? :manager
#      can :manage, [User, Item, Unit, Vendor, Owner, Comment, Identifier, Group, Checkout, CheckoutItems], :department_id => user.department_id
      can :manage, [User, Item, Unit, Vendor, Owner, Comment, Identifier, Group, Checkout, Cloth], :department_id => user.department_id
      can [:create, :read, :update], [Category, SubCategory, Status]
      can :last_seen, Item
      cannot :manage, [Role, Department, UnitType]
      cannot :assign_roles, User
    end

    if user.has_role? :service
      can [:read, :update], Item, :department_id => user.department_id
      can :manage, [Comment, Identifier, Checkout], :department_id => user.department_id
      can :read, [Category, SubCategory, Unit]
      can [:create, :read, :update], ServiceEvent
      can :last_seen, Item
      can :manage, Cloth, :user_id => user.id
#      can :manage, [Comment, Identifier, Checkout, CheckoutItems], :department_id => user.department_id
#      cannot :manage, [Role, Department, UnitType, Group, User]
    end

    if user.has_role? :superuser
      can :manage, :all
    end

    if user.has_role? :sms
#      can :manage, Sms
      can :read, [User, Group]
      can :update, Group, :department_id => user.department_id
    end

    if user.has_role? :view
      can :read, [Item, Unit, Vendor, Owner, Comment, Identifier], :department_id => user.department_id
      can :read, [Category, SubCategory]
#      can :read, [Item, Unit, Vendor, Owner, Comment, Identifier]
#      cannot :manage, [Role, Department, UnitType, Group, User]
    else
#      cannot :manage, :all
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
