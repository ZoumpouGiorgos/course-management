class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :validatable,
       :omniauthable, omniauth_providers: %i[google_oauth2]
         
  has_many :posts, dependent: :destroy

  validates :username, presence: true, uniqueness: true

  has_many :contacts, dependent: :destroy
  has_many :contact_users, through: :contacts, source: :contact_user, dependent: :destroy

  has_many :conversation_participants, dependent: :destroy
  has_many :conversations, through: :conversation_participants, dependent: :destroy

  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  def self.from_google(auth)
    user = User.find_by(email: auth.info.email)

    if user.nil?
      user = User.create!(
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        username: (auth.info.name.presence || auth.info.email.split("@").first)
      )
    end

    user
  end
end
