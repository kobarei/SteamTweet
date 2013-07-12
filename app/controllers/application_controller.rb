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
      @now_playing = current_user.games.find_by_appid(appid)
    when 1
      @status = 'Online'
      @now_playing = current_user.games.find_by_appid(appid)
    when 2
      @status = 'Busy'
      @now_playing = current_user.games.find_by_appid(appid)
    when 3
      @status = 'Away'
      @now_playing = current_user.games.find_by_appid(appid)
    when 4
      @status = 'Snooze'
      @now_playing = current_user.games.find_by_appid(appid)
    when 5
      @status = 'LookingToTrade'
      @now_playing = current_user.games.find_by_appid(appid)
    when 6
      @status = 'LookingToPlay'
      @now_playing = current_user.games.find_by_appid(appid)
    end
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
