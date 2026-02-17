class ApplicationController < ActionController::Base
  include Pagy::Method
  allow_browser versions: :modern

  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  before_action :load_sidebar_data

  private

  def load_sidebar_data
    return unless user_signed_in?

    @sidebar_users = current_user.contacts.includes(:contact_user).map(&:contact_user).compact

    @sidebar_conversations =
      current_user.conversations
        .includes(:participants, messages: :user)
        .order(updated_at: :desc)
        .limit(20)
  end
end
