class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers
  has_many :raters, through: :beers
  has_many :styles, through: :beers

  validates_presence_of :name
  validate :validate_year

  scope :active, -> { where(active: true) }
  scope :retired, -> { where(active: [nil, false]) }

  # Select the n top rated breweries ranked by average rating score.
  # Includes the average scores.
  def self.top(n)
    joins(:ratings).
        select('breweries.*', 'SUM(score)/COUNT(score) AS average_score').
        group('breweries.id').order('average_score DESC').limit(n)
  end

  def validate_year
    if 1042 > year || year > Date.today.year
      errors.add(:year, "has to be between 1042 and present")
    end
  end

  def to_s
    name
  end
end
