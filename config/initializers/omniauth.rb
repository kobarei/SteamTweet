Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET
  provider :steam, STEAM_API_KEY
end
