class TweetController < ApplicationController
  def update
    if current_user
      current_user.update_steam_status
      steam = DALLI.get(current_user.steam.uid)
      state(steam[:status], steam[:appid])

      client = setup_twitter_client
      begin
        if @now_playing
          msg = "I'm now playing #{@now_playing.name} #NowGamingSteam"
          client.update(msg)
        else
          msg = "I'm now #{@status} #steam"
          client.update(msg)
        end
        redirect_to :root, :notice => "Tweeted '#{msg}'"
      rescue Twitter::Error
        redirect_to :root, :notice => "Hey Loser, Twitter says you cannot post same twice"
      end 
    else
      redirect_to :root, :notice => 'Hey Loser, Usr should login first'
    end
  end
end
