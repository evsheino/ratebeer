class User < ActiveRecord::Base
  include RatingAverage

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  has_many :confirmed_memberships, -> {confirmed}, class_name: 'Membership'
  has_many :pending_memberships, -> {pending}, class_name: 'Membership'
  has_many :beer_clubs_where_confirmed_member, through: :confirmed_memberships, source: :beer_club
  has_many :beer_clubs_where_application_pending, through: :pending_memberships, source: :beer_club

  has_secure_password

  validates_uniqueness_of :username
  validates :password, :format => {:with => /\A.*(?=.{4,})(?=.*\d)(?=.*[a-zA-Z]).*\z/,
                                   message: "must be at least 4 characters and include one number and one letter."}
  validates_length_of :username, :minimum => 3, :maximum => 15

  # Order by rating count and include rating count.
  def self.order_by_activity
    select('users.*', 'COUNT(ratings.id) AS rating_count').
        joins('LEFT OUTER JOIN ratings ON users.id = ratings.user_id').
        group('users.id').order('rating_count DESC')
  end

  def self.top(n)
    order_by_activity.limit(n)
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(:score).last.beer
  end

  # Get the style that has the highest average rating among beers the user has rated.
  def favorite_style
    return nil if ratings.empty?
    Style.joins(:raters).group('users.id', :id).
        having('users.id = ?', id).
        order('AVG(score) DESC').
        first
  end

  # Get the brewery that has the highest average rating among beers the user has rated.
  def favorite_brewery
    return nil if ratings.empty?
    Brewery.joins(:raters).group('users.id', :id).
        having('users.id = ?', id).
        order('AVG(score) DESC').
        first
  end

  def to_s
    username
  end
end
