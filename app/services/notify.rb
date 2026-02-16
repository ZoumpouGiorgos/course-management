class Notify
  def self.call(recipient:, actor: nil, action:, notifiable: nil, text:, metadata: {})
    n = Notification.create!(
      recipient: recipient,
      actor: actor,
      action: action,
      notifiable: notifiable,
      metadata: (metadata.merge("text" => text)).to_json
    )

    Turbo::StreamsChannel.broadcast_prepend_to(
      "notifications_#{recipient.id}",
      target: "notifications_list",
      partial: "notifications/item",
      locals: { notification: n }
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      "notifications_#{recipient.id}",
      target: "notifications_badge",
      partial: "notifications/badge",
      locals: { user: recipient }
    )

    n
  end
end
