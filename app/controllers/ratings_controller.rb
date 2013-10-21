class RatingsController < ApplicationController
  before_filter :ensure_that_signed_in, :except => [:index, :top_users]
  before_action :set_rating, only: [:destroy]

  TOP_BREWERIES_CACHE_KEY = 'breweries/top'
  TOP_BEERS_CACHE_KEY = 'beers/top'
  TOP_STYLES_CACHE_KEY = 'styles/top'
  TOP_USERS_CACHE_KEY = 'users/top'

  def index
    Rails.cache.write(TOP_BREWERIES_CACHE_KEY, Brewery.top(3)) unless Rails.cache.exist?(TOP_BREWERIES_CACHE_KEY)
    Rails.cache.write(TOP_BEERS_CACHE_KEY, Beer.top(3)) unless Rails.cache.exist?(TOP_BEERS_CACHE_KEY)
    Rails.cache.write(TOP_STYLES_CACHE_KEY, Style.top(3)) unless Rails.cache.exist?(TOP_STYLES_CACHE_KEY)
    Rails.cache.write(TOP_USERS_CACHE_KEY, User.top(3)) unless Rails.cache.exist?(TOP_USERS_CACHE_KEY)

    @ratings = Rating.all
    @recent_ratings = Rating.recent

    @top_users = Rails.cache.read(TOP_USERS_CACHE_KEY)
    @top_breweries = Rails.cache.read(TOP_BREWERIES_CACHE_KEY)
    @top_styles = Rails.cache.read(TOP_STYLES_CACHE_KEY)
    @top_beers = Rails.cache.read(TOP_BEERS_CACHE_KEY)
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