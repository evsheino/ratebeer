class Style < ActiveRecord::Base
  has_many :beers
  has_many :raters, through: :beers
  has_many :breweries, through: :beers
  has_many :ratings, through: :beers

  def self.top(n)
    joins(:ratings).
        select('styles.*', 'SUM(score)/COUNT(score) AS average_score').
        group('styles.id').order('average_score DESC').limit(n)
  end

  def to_s
    name
  end
end
