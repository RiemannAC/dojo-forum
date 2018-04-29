class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :generate_authentication_token

  has_many :posts, dependent: :destroy

  has_many :comments, dependent: :destroy
  has_many :commented_posts, through: :comments, source: :post

  has_many :vieweds, dependent: :destroy
  has_many :viewed_posts, through: :vieweds, source: :post

  has_many :collections, dependent: :destroy
  has_many :collected_posts, through: :collections, source: :post

  mount_uploader :avatar, AvatarUploader

  def admin?
    self.role == "admin"
  end

  def generate_authentication_token
     self.authentication_token = Devise.friendly_token
  end

end
