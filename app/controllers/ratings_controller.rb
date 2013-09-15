class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
  end

  def create
    Rating.create(rating_params)
    redirect_to ratings_path
  end

  def rating_params
    params.require(:rating).permit(:score, :beer_id)
  end
end