class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :contact_user, class_name: "User"

  validates :contact_user_id, uniqueness: { scope: :user_id }
  validate :not_self

  def not_self
    errors.add(:contact_user_id, "can't be yourself") if user_id == contact_user_id
  end
end
