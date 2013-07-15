class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :add_steam

  # GET /users
  # GET /users.json
  def index
    if current_user && current_user.steam.present?
      @games = current_user.games
      steam = DALLI.get(current_user.steam.uid)
      state(steam[:status], steam[:appid])
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if current_user.steam
      if current_user.games
        current_user.games.each { |game| game.destroy }
      end
      current_user.steam.destroy
    end
    current_user.destroy
    session[:user_id] = nil
    respond_to do |format|
      format.html { redirect_to :root }
      format.json { head :no_content }
    end
  end

  def add_steam
    auth = request.env['omniauth.auth']
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
    redirect_to root_url, :notice => 'Steam Integrated!'
  end

  def status_update
    player_update(current_user)
    steam = DALLI.get(current_user.steam.uid)
    state(steam[:status], steam[:appid])
  end

  def games_update
    begin
      game_info = JSON.parse(open("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{STEAM_API_KEY}&steamid=#{current_user.steam.uid}&include_appinfo=1").read)
      game_info['response']['games'].each do |info|
        unless current_user.games.find_by_appid(info['appid'])
          game = Game.new
          game.user_id = current_user.id
          game.appid = info['appid']
          game.name = info['name']
          game.logo = info['img_logo_url']
          if info['playtime_2week']
            game.playtime_2week = info['playtime_2week']
          end
          if info['playtime_forever']
            game.playtime_forever = info['playtime_forever']
          end
          game.save
        end
      end
    rescue
    end
    @games = current_user.games
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:provider, :uid, :name, :steam)
    end

end
