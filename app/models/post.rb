class Post < ApplicationRecord
  belongs_to :user

  has_many :category_posts
  has_many :categories, through: :category_posts

  has_many :comments, dependent: :destroy
  has_many :commented_users, through: :comments, source: :user

  has_many :vieweds, dependent: :destroy
  has_many :viewed_users, through: :vieweds, source: :user

  mount_uploader :image, ImageUploader

  # 對單數
  def public?
    self.status == "public"
  end

  # 對複數 @category.posts
  def self.are_public?
    Post.where(status: "public")
  end

end
