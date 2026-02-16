class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
       :rememberable, :validatable, :omniauthable,
       omniauth_providers: %i[google_oauth2]
         
  has_many :posts, dependent: :destroy

  validates :username, presence: true, uniqueness: true

  has_many :contacts, dependent: :destroy
  has_many :contact_users, through: :contacts, source: :contact_user, dependent: :destroy

  has_many :conversation_participants, dependent: :destroy
  has_many :conversations, through: :conversation_participants, dependent: :destroy

  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  def self.from_google(auth)
    email = auth.info.email
    name  = auth.info.name

    user = User.find_by(email: email)
    return user if user

    base = (name.presence || email.split("@").first).parameterize(separator: "_")
    username = base
    i = 1
    while User.exists?(username: username)
      i += 1
      username = "#{base}_#{i}"
    end

    User.create!(
      email: email,
      username: username,
      password: Devise.friendly_token[0, 20]
    )
  end
end