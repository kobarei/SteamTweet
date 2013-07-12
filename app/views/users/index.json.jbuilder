json.array!(@users) do |user|
  json.extract! user, :provider, :uid, :name, :steam
  json.url user_url(user, format: :json)
end
