class Comment < ActiveRecord::Base # Polymorphic is done to create nested comments i.e. Post has comments and each comments can have many other comments(replies)
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  validates :body, presence: true
end
