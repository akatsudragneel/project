class Ability             # model which tells the part of accessible to user depending upon their roles.
  include CanCan::Ability # Accessibilty is controlled using cancan
  
  def initialize(user)    # For handling access to certain modules using cancan gem
    user ||= User.new     # Guest user

    alias_action :create, :read, :update, :destroy, to: :crud

    if user.superadmin?   # Super Admin can access all 
      can :manage, :all
    end

    if user.admin?     # Admin have limited access.It can read read and create user but deleting power is only to super admin
      can :crud, User
      can :read, Event
      can :read, Group
      can :new, Group
      can :crud, Post
      can :create, Comment
      can :update, Group do |group|
        group.try(:user) == user || group.created_by == (user.name)
      end
      can :create, Group do |group|
        group.try(:user) == user || group.created_by == (user.name)
      end
      can :destroy, Group do |group|
        group.try(:user) == user || group.created_by == (user.name)
      end
      can :add_members, Group do |group|
        group.try(:user) == user || group.created_by == (user.name)
      end
      can :add_member, Group do |group|
        group.try(:user) == user || group.created_by == (user.name)
      end
      can :remove_member, Group do |group|
        group.try(:user) == user || group.created_by == (user.name)
      end
      can :destroy, Post do |post|
        post.try(:user) == user || post.user_id == (user.id)
      end

      can [:update,:create,:destroy,:edit,:add_members], Group do |group|
        group.try(:user) == user || group.created_by== (user.name)
      end       
      can [:update,:create,:destroy,:read,:edit], Comment do |comment|
        comment.try(:user) == user || comment.name == (user.name)
      end
    end

    if user.regular?  # Regular user can only view Groups.It cant even access admin panel
      can :read, Event
      can :read, Group
      can [:update,:create,:destroy,:edit,:add_members], Group do |group|
        group.try(:user) == user || group.created_by== (user.name)
      end 
      can :like, Post
      can :update, Post
      can :read, Post
      can :create, Comment
      can :update, Comment do |comment|
        comment.try(:user) == user || comment.name == (user.name)
      end
      can :destroy, Comment do |comment|
        comment.try(:user) == user || comment.name == (user.name)
      end
      can :read, Comment do |comment|
        comment.try(:user) == user || comment.name == (user.name)
      end
      can [:update,:create,:destroy,:read,:edit], Comment do |comment|
        comment.try(:user) == user || comment.name == (user.name)
      end   
    end
  end
end