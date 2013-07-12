json.array!(@games) do |game|
  json.extract! game, :user_id, :appid, :name, :playtime_2weeks, :playtime_forever, :logo
  json.url game_url(game, format: :json)
end
