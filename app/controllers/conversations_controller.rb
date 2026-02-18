class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def create
    other_id = params[:user_id].presence&.to_i

    if other_id
      @conversation = find_dm_conversation(current_user.id, other_id)

      unless @conversation
        @conversation = Conversation.create!(title: nil)
        ConversationParticipant.create!(conversation: @conversation, user_id: current_user.id)
        ConversationParticipant.create!(conversation: @conversation, user_id: other_id)
      end
    else
      user_ids = Array(params[:user_ids]).reject(&:blank?).map(&:to_i).uniq
      user_ids << current_user.id
      user_ids.uniq!

      @conversation = Conversation.create!(title: params[:title].presence)
      user_ids.each { |id| ConversationParticipant.create!(conversation: @conversation, user_id: id) }
    end

    @message = Message.new
    render "conversations/modal", layout: false
  end

  def close_chat_modal
    render html: "<turbo-frame id='chat_modal'></turbo-frame>".html_safe, layout: false
  end

  def new
    @q = params[:q].to_s.strip

    @users = User.where.not(id: current_user.id)

    if @q.present?
      term = "%#{@q.downcase}%"
      @users = @users.where("LOWER(username) LIKE ? OR LOWER(email) LIKE ?", term, term)
    end

    @users = @users.order(:username)

    @conversation = Conversation.new
  end


  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.includes(:user).order(:created_at)
    @message  = Message.new(conversation: @conversation, user: current_user)
    render "conversations/modal", layout: false
  end


  private

  def find_dm_conversation(user_a_id, user_b_id)
    Conversation
      .joins(:conversation_participants)
      .where(conversation_participants: { user_id: [user_a_id, user_b_id] })
      .group("conversations.id")
      .having("COUNT(DISTINCT conversation_participants.user_id) = 2")
      .first
  end
end
