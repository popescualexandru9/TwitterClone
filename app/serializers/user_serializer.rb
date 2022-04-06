class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :handle, :email, :bio

  has_many :tweets
  has_many :tweets_liked

  has_many :followers
  has_many :followings
end
