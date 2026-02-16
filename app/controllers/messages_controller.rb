class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    conversation = Conversation.find(params[:conversation_id])

    message = conversation.messages.create!(
      user: current_user,
      body: params.require(:message)[:body]
    )

    recipients = conversation.participants.where.not(id: current_user.id)

    recipients.find_each do |recipient|
      Notify.call(
        recipient: recipient,
        actor: current_user,
        action: "message",
        notifiable: message,
        text: "#{current_user.username} sent you a message",
        metadata: {
          "conversation_id" => conversation.id,
          "message_id" => message.id
        }
      )
    end

    head :ok
  end
end
