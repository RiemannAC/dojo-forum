class Category < ApplicationRecord
  has_many :category_posts, dependent: :restrict_with_error
  has_many :posts, through: :category_posts

end
