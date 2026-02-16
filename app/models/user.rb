class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable 
         
  has_many :posts, dependent: :destroy

  validates :username, presence: true, uniqueness: true

  has_many :contacts, dependent: :destroy
  has_many :contact_users, through: :contacts, source: :contact_user, dependent: :destroy

  has_many :conversation_participants, dependent: :destroy
  has_many :conversations, through: :conversation_participants, dependent: :destroy

  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
end
