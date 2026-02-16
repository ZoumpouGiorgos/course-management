class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]

    user = User.from_google(auth)
    sign_in_and_redirect user, event: :authentication
  end

  def failure
    redirect_to new_user_session_path, alert: (params[:message].presence || "Google sign-in failed.")
  end
end