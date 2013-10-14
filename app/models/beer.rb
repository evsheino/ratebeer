class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates_presence_of :name
  validates_presence_of :style_id

  # Select the n top rated beers ranked by average rating score.
  # Includes the average scores.
  def self.top(n)
    joins(:ratings).
        select('beers.*', 'SUM(score)/COUNT(score) AS average_score').
        group('beers.id').order('average_score DESC').limit(n)
  end

  def to_s
    "#{brewery.name} #{name}"
  end
end
