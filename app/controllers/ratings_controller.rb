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
    @rating = Rating.new(rating_params)
    @rating.user = current_user
    respond_to do |format|
      if @rating.save
        format.html { redirect_to @rating.user, notice: 'Rating was successfully created.' }
      else
        @beers = Beer.all
        format.html { render action: 'new' }
      end
    end
  end

  def destroy
    @rating.destroy if current_user == @rating.user
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