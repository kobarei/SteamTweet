class Game < ActiveRecord::Base
  belongs_to :user

  def self.add(current_user)
    begin
      game_info = JSON.parse(open("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{STEAM_API_KEY}&steamid=#{current_user.steam.uid}&include_appinfo=1").read)
      game_info['response']['games'].each do |info|
        game = Game.find_by(:user_id => current_user.id, :appid => info['appid'])
        unless game.present?
          game = Game.new(
            :user_id => current_user.id,
            :appid   => info['appid'],
            :name    => info['name'],
            :logo    => info['img_logo_url']
          )
        end
        game.playtime_2weeks  = info['playtime_2weeks']  if info['playtime_2weeks']
        game.playtime_forever = info['playtime_forever'] if info['playtime_forever']
        game.save
      end
    rescue
    end
  end

end
