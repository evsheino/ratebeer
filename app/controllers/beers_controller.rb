class BeersController < ApplicationController
  before_filter :ensure_that_signed_in, :except => [:index, :show]
  before_action :set_beer, only: [:show, :edit, :update, :destroy]

  ALLOWED_SORT_PARAMS = ['name', 'brewery', 'style']

  # GET /beers
  # GET /beers.json
  def index
    order = ALLOWED_SORT_PARAMS.include?(params[:order]) ? params[:order] : 'name'
    @beers = Beer.all.sort_by{ |b| b.send(order) }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @beers }
  end
  end

  # GET /beers/1
  # GET /beers/1.json
  def show
    @rating = Rating.new
    @rating.beer = @beer

    respond_to do |format|
      format.html
      format.json { render json: @beer }
    end
  end

  # GET /beers/new
  def new
    @beer = Beer.new
    set_styles
    set_breweries
  end

  # GET /beers/1/edit
  def edit
    set_styles
    set_breweries
  end

  # POST /beers
  # POST /beers.json
  def create
    @beer = Beer.new(beer_params)

    respond_to do |format|
      if @beer.save
        format.html { redirect_to beers_path, notice: 'Beer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @beer }
      else
        set_styles
        set_breweries
        format.html { render action: 'new' }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beers/1
  # PATCH/PUT /beers/1.json
  def update
    respond_to do |format|
      if @beer.update(beer_params)
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { head :no_content }
      else
        set_styles
        set_breweries
        format.html { render action: 'edit' }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1
  # DELETE /beers/1.json
  def destroy
    @beer.destroy
    respond_to do |format|
      format.html { redirect_to beers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer
      @beer = Beer.find(params[:id])
    end

    def set_styles
      @styles = Style.all
    end

    def set_breweries
      @breweries = Brewery.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beer_params
      params.require(:beer).permit(:name, :style_id, :brewery_id)
    end
end
