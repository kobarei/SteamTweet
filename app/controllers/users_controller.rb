class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :add_steam

  def index
    if current_user && current_user.steam.present?
      @games = current_user.games
      if steam = DALLI.get(current_user.steam.uid)
        state(steam[:status], steam[:appid])
      end
    end
  end

  def destroy
    if current_user.steam
      if current_user.games
        current_user.games.each { |game| game.destroy }
      end
      current_user.steam.destroy
    end
    current_user.destroy
    redirect_to :signout
  end

  def add_steam
    auth = request.env['omniauth.auth']
    current_user.create_steam_account(auth) if current_user.steam.nil?
    Game.add(current_user)
    redirect_to root_url, :notice => 'Steam Integrated!'
  end

  def status_update
    current_user.update_steam_status
    steam = DALLI.get(current_user.steam.uid)
    state(steam[:status], steam[:appid])
  end

  def games_update
    Game.add(current_user)
    @games = current_user.games
  end

end
