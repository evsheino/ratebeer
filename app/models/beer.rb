class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates_presence_of :name
  validates_presence_of :style

  def to_s
    "#{brewery.name} #{name}"
  end
end
