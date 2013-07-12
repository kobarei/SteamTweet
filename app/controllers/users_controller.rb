class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if current_user && current_user.steam.present?
      @games = current_user.games
      appid = nil
      state(DALLI.get(current_user.steam.uid), appid)
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def status_update
    begin
      steam_user = JSON.parse(open("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{STEAM_API_KEY}&steamids=#{current_user.steam.uid}").read)
      DALLI.set(current_user.steam.uid, steam_user['response']['players'].first['personastate'])
      appid = steam_user['response']['players'].first['gameid']
    rescue
    end
    state(DALLI.get(current_user.steam.uid), appid)
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
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:provider, :uid, :name, :steam)
    end

end
