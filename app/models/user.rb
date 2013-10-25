class User < ActiveRecord::Base
  has_one :steam
  has_many :games

  def self.create_with_omniauth(auth)
    create!do |user|  
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
      user.twitter_image = auth["info"]["image"]
    end
  end

  def create_steam_account(auth)
    steam = Steam.new
    steam.user_id  = self.id
    steam.provider = auth.provider
    steam.uid      = auth.uid
    steam.name     = auth.info.name
    steam.image    = auth.extra.raw_info.avatarfull
    steam.save
    DALLI.set(steam.uid, {:status => auth.extra.raw_info.profilestate, :appid => nil})
  end

  def update_steam_status
    begin
      player_summary = JSON.parse(open("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{STEAM_API_KEY}&steamids=#{self.steam.uid}").read)
      DALLI.set(self.steam.uid, {
        :status => player_summary['response']['players'].first['personastate'], 
        :appid => player_summary['response']['players'].first['gameid']
      })
    rescue
    end
  end
end
