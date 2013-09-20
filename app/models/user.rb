class User < ActiveRecord::Base
  include RatingAverage

  has_many :ratings

  def to_s
    username
  end
end
