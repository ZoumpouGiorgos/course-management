ENV["GOOGLE_CLIENT_ID"]     ||= Rails.application.credentials.dig(:google, :client_id)
ENV["GOOGLE_CLIENT_SECRET"] ||= Rails.application.credentials.dig(:google, :client_secret)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV.fetch("GOOGLE_CLIENT_ID"),
           ENV.fetch("GOOGLE_CLIENT_SECRET"),
           { prompt: "select_account" }
end