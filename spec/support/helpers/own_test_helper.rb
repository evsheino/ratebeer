module OwnTestHelper
  def sign_in(username, password)
    visit signin_path
    fill_in('username', :with => username)
    fill_in('password', :with => password)
    click_button('Log in')
  end

  def create_beers_with_ratings(*scores, user, style)
    beers = []
    scores.each do |score|
      beers << create_beer_with_rating(score, user, style)
    end
    beers
  end

  def create_beer_with_rating(score,  user, style)
    beer = FactoryGirl.create(:beer_stub, style: style)
    FactoryGirl.create(:rating, :score => score,  :beer => beer, :user => user)
    beer
  end
end