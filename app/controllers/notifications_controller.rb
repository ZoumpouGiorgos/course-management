class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def read
    notification = current_user.notifications.find(params[:id])
    notification.update!(read_at: Time.current) if notification.read_at.nil?

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: posts_path }
    end
  end
end