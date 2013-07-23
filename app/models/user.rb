class User < ActiveRecord::Base
  has_one :steam
  has_many :games

  def self.create_with_omniauth(auth)
    create!do |user|  
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.token = auth["credentials"]["token"]
      user.secret = auth["credentials"]["secret"]
      user.name = auth["info"]["nickname"]
      user.twitter_image = auth["info"]["image"]
    end
  end
end
