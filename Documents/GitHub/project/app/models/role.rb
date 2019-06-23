class Role < ActiveRecord::Base # Role can be admin, superadmin and regular
  has_many :users
end
