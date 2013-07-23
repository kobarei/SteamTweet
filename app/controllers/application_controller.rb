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

  def player_update(current_user)
    begin
      player_summary = JSON.parse(open("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{STEAM_API_KEY}&steamids=#{current_user.steam.uid}").read)
      DALLI.set(current_user.steam.uid, {
        :status => player_summary['response']['players'].first['personastate'], 
        :appid => player_summary['response']['players'].first['gameid']
      })
    rescue
    end
  end
end
