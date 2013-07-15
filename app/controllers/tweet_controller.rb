class TweetController < ApplicationController
  def input
  end

  def update
    if current_user
      player_update(current_user)
      steam = DALLI.get(current_user.steam.uid)
      state(steam[:status], steam[:appid])

      client = Twitter::Client.new(
        :consumer_key => TWITTER_CONSUMER_KEY,
        :consumer_secret => TWITTER_CONSUMER_SECRET,
        :oauth_token => current_user.token,
        :oauth_token_secret => current_user.secret
      )
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
