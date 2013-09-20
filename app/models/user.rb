class User < ActiveRecord::Base
  include RatingAverage

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  has_secure_password

  validates_uniqueness_of :username
  validates_length_of :password, :minimum => 4
  validates_length_of :username, :minimum => 3, :maximum => 15

  def to_s
    username
  end
end
