Rails.application.config.middleware.use OmniAuth::Builder do
  provider :zoom, ENV['OAUTH_CLIENT_ID'], ENV['OAUTH_CLIENT_SECRET'], provider_ignores_state: true
end
