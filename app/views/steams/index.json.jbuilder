json.array!(@steams) do |steam|
  json.extract! steam, :user_id, :provider, :uid, :name, :image
  json.url steam_url(steam, format: :json)
end
