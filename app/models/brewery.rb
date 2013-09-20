class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, allow_blank: false
  validates_numericality_of :year, { :greater_than_or_equal_to => 1042,
                                      :less_than_or_equal_to => 2013,
                                      :only_integer => true }

  def to_s
    name
  end
end
