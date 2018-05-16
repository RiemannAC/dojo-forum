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

  has_many :friendships, -> { where status: true }, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :inverse_friendships, -> {where status: true}, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  has_many :request_friendships, -> {where status: false}, class_name: "Friendship", dependent: :destroy
  has_many :request_friends, through: :request_friendships, source: :friend

  has_many :inverse_request_friendships, -> {where status: false}, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :inverse_request_friends, through: :inverse_request_friendships, source: :user

  mount_uploader :avatar, AvatarUploader

  def admin?
    self.role == "admin"
  end

  def generate_authentication_token
     self.authentication_token = Devise.friendly_token
  end

  # status: true
  def friend?(user)
    self.friends.include?(user) || self.inverse_friends.include?(user)
  end

  # uniq 避免重覆
  def all_friends
    friends = self.friends + self.inverse_friends
    return friends.uniq
  end

  # status: false
  def request_friend?(user)
    self.request_friends.include?(user)
  end

  # status: false
  def inverse_request_friend?(user)
    self.inverse_request_friends.include?(user)
  end

end
