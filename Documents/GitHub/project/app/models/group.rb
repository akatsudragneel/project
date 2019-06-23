class Group < ActiveRecord::Base # Group model for handling Group which can have many menbers and many posts
  
  has_many :memberships, :dependent => :destroy
  has_many :users, through: :memberships
  accepts_nested_attributes_for :memberships # this is done for allowing nested form while creating new group for selecting members
  has_many :posts, :dependent => :destroy
  
  validates :name, presence: true, length: {minimum: 5}
  validates :desc, presence: true

end
