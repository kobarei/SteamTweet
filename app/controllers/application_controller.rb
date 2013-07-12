class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :signed_in?
  helper_method :current_user

  private
  def current_user  
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def state(num, appid)
    case num
    when 0
      @status = 'Offline'
    when 1
      @status = 'Online'
      unless appid == nil
        @now_playing = current_user.games.find_by_appid(appid)
      end
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
  end
end
