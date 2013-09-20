class RatingsController < ApplicationController
  before_action :set_rating, only: [:destroy]

  def index
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    rating = Rating.new(rating_params)
    rating.user = current_user
    rating.save

    redirect_to ratings_path
  end

  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    def set_rating
      @rating = Rating.find(params[:id])
    end

    def rating_params
      params.require(:rating).permit(:score, :beer_id)
    end
end