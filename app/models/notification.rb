class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User", optional: true
  belongs_to :notifiable, polymorphic: true, optional: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def read?
    read_at.present?
  end

  def metadata_hash
    JSON.parse(metadata.presence || "{}")
  rescue JSON::ParserError
    {}
  end

  def text
    metadata_hash["text"].presence || action
  end
end
