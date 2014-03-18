class Ability
  include CanCan::Ability

  def initialize(user)
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
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    user ||= User.new

    alias_action :create, :read, :update, :to => :all_but_destroy
    if user.id # Any authenticated user
      can :read, [Library, Floor, SubjectArea, CallNumber, ReservableAsset]
      can :assets, Floor
      can :read, Reservation, :user_id => user.id
      can :create, Reservation do |r|
        r.reservable_asset.reservable_asset_type.user_types.pluck(:id).select do |ut|
          user.user_types.pluck(:id).include? ut
        end.count >= 1
      end
      can :expire, Reservation, :user_id => user.id
      can :reserve, ReservableAsset do |ra|
        ra.reservable_asset_type.user_types.pluck(:id).select do |ut|
          user.user_types.pluck(:id).include? ut
        end.count >= 1
      end
      can :read, BulletinBoard do |bb|
        BulletinBoard.joins(:reservable_asset => {:reservations => :user}).where('users.id = ?', user.id).include? bb
      end

      if user.admin? # Global Admin
        can :manage, :all
      elsif user.local_admin_permissions.count > 0 # Local admin
        can :all_but_destroy, User
        can :manage, Library, :id => user.local_admin_permissions.pluck(:id)
        can :manage, [CallNumber, Floor, ReservableAsset, ReservableAssetType, ReservationNotice, SubjectArea, UserType] do |obj|
          user.local_admin_permissions.include?(obj.library)
        end
        can :reserve, ReservableAsset, :library => user.local_admin_permissions.all
        can :manage, Reservation, :library => user.local_admin_permissions.all
      end
    else # Unauthed Users

    end
  end
end
