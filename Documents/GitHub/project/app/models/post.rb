class Post < ActiveRecord::Base# User and group can have many posts and each posts can have many comments.
  belongs_to :user
  belongs_to :group
  acts_as_votable
  has_many  :comments, as: :commentable, dependent: :destroy
  validates :title, presence: true, length: {minimum: 5}
  validates :body, presence: true
end
