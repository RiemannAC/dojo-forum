class Post < ApplicationRecord
  belongs_to :user

  has_many :category_posts
  has_many :categories, through: :category_posts

  has_many :comments, dependent: :destroy
  has_many :commented_users, through: :comments, source: :user

  mount_uploader :image, ImageUploader
end
