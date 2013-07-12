class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def create
    auth = request.env['omniauth.auth']
    if auth.provider == 'twitter'
      user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.create_with_omniauth(auth)
      session[:user_id] = user.id
    elsif auth.provider == 'steam'
      if current_user.steam.nil?
        steam = Steam.new
        steam.user_id = current_user.id
        steam.provider = auth.provider
        steam.uid = auth.uid
        steam.name = auth.info.name
        steam.image = auth.extra.raw_info.avatarfull
        steam.save
        DALLI.set(steam.uid, {:status => auth.extra.raw_info.profilestate, :appid => nil})

        begin
          game_info = JSON.parse(open("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{STEAM_API_KEY}&steamid=#{current_user.steam.uid}&include_appinfo=1").read)
          game_info['response']['games'].each do |info|
            game = Game.new
            game.user_id = current_user.id
            game.appid = info['appid']
            game.name = info['name']
            game.logo = info['img_logo_url']
            if info['playtime_2weeks']
              game.playtime_2week = info['playtime_2week']
            end
            if info['playtime_forever']
              game.playtime_forever = info['playtime_forever']
            end
            game.save
          end
        rescue
        end
      end
    end
    redirect_to root_url, :notice => 'Signed in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Signed out!'
  end
end
