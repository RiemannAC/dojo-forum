class Post < ApplicationRecord
  validates_presence_of :title, :content

  belongs_to :user

  has_many :category_posts
  has_many :categories, through: :category_posts

  has_many :comments, dependent: :destroy
  has_many :commented_users, through: :comments, source: :user

  has_many :vieweds, dependent: :destroy
  has_many :viewed_users, through: :vieweds, source: :user

  mount_uploader :image, ImageUploader

  # 對單數
  def is_public?
    self.status == "public"
  end

  # 對複數 @category.posts 或 Post
  def self.are_public?
    Post.where(status: "public")
  end

  # Chaining Query Rails 5 按 all，friend，myself partition 依序 query
  def self.are_viewable?(user)
    Post.where(
      authority: "all").
    or(where(authority: "myself", user: user)#).
    # or(where(user: user)).                    # current_user all friends 是否包含 current_user 自己，待測
    # or(where(authority: "friend", user: user) # 朋友關係待新增
    )
  end

end
