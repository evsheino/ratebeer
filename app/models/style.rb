class Style < ActiveRecord::Base
  has_many :beers
  has_many :raters, through: :beers
  has_many :breweries, through: :beers
  has_many :ratings, through: :beers

  def to_s
    name
  end
end
