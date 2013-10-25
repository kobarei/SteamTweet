class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :signed_in?
  helper_method :current_user

  def current_user  
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def state(num, appid)
    case num
    when 0
      @status = 'Offline'
    when 1
      @status = 'Online'
    when 2
      @status = 'Busy'
    when 3
      @status = 'Away'
    when 4
      @status = 'Snooze'
    when 5
      @status = 'LookingToTrade'
    when 6
      @status = 'LookingToPlay'
    end
    @now_playing = current_user.games.find_by_appid(appid)
  end

  def setup_twitter_client
    client = Twitter::Client.new(
      :consumer_key => TWITTER_CONSUMER_KEY,
      :consumer_secret => TWITTER_CONSUMER_SECRET,
      :oauth_token => session[:token],
      :oauth_token_secret => session[:secret]
    )
    return client
  end
end
