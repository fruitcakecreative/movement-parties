class User < ApplicationRecord
  before_create :generate_authentication_token

  def generate_authentication_token
    self.authentication_token ||= SecureRandom.hex(20)
  end

  # Devise modules for authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  # Associations
  has_many :event_attendees
  has_one_attached :avatar
  has_many :events, through: :event_attendees
  has_many :user_events, dependent: :destroy
  has_many :events, through: :user_events
  has_many :friendships
  has_many :friends, -> { where(friendships: { status: 'accepted' }) }, through: :friendships
  has_many :pending_friendships, -> { where(status: 'pending') }, class_name: 'Friendship'
  has_many :incoming_friend_requests, -> { where(status: 'pending') }, class_name: 'Friendship', foreign_key: :friend_id

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :picture, presence: true, allow_blank: true

  # facebook login
  def self.from_facebook(auth)
    user = find_or_create_by(email: auth.info.email) do |user|
      user.name = auth.info.name
      user.picture = auth.info.image
      user.username = "#{auth.info.name.parameterize}-#{SecureRandom.hex(4)}" # Ensure uniqueness
      user.password = Devise.friendly_token[0, 20]  # Temporarily set a password for Facebook login
    end
    user
  end

  # update profile from facebook info
  def update_from_facebook(auth)
    if name != auth.info.name || email != auth.info.email || picture != auth.info.image
      self.name = auth.info.name
      self.email = auth.info.email
      self.picture = auth.info.image
      save
    end
  end
end
