class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def average_rating
    ratings.inject(0) {|sum, rating| sum + rating.score}.to_f / ratings.count
    #ratings.average(:score)
  end

  def to_s
    "#{brewery.name} #{name}"
  end
end
