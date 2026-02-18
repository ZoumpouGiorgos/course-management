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
    name  = auth.info.name.to_s.strip

    base =
      if name.present?
        name.parameterize(separator: "_")
      else
        email.split("@").first.parameterize(separator: "_")
      end

    if (!base.present?)
      base = "user_"
    end

    username = base

    i = 0
    while User.exists?(username: username)
      i += 1
      username = "#{base}_#{i}"
    end


    where(email: email).first_or_create! do |u|
      u.username = username
      u.password = Devise.friendly_token.first(20)
    end
  end
end