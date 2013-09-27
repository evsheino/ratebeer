class User < ActiveRecord::Base
  include RatingAverage

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  has_secure_password

  validates_uniqueness_of :username
  validates :password, :format => {:with => /\A.*(?=.{4,})(?=.*\d)(?=.*[a-zA-Z]).*\z/,
                                   message: "must be at least 4 characters and include one number and one letter."}
  validates_length_of :username, :minimum => 3, :maximum => 15

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(:score).last.beer
  end

  # Get the style that has the highest average rating among beers the user has rated.
  def favorite_style
    return nil if ratings.empty?
    Beer.joins(:raters).group('users.id', :style)
      .having('users.id = ?', id)
      .order('SUM(score)/COUNT(score) DESC')
      .first[:style]
  end

  def to_s
    username
  end
end
