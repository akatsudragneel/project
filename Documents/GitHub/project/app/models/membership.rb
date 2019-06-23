class Membership < ActiveRecord::Base # Membership holds just references for all users belonging to some specific group.Has both user_id and group_id stored in a Tuple 
  belongs_to :user
  belongs_to :group
end
