require 'spec_helper'

describe "Rating" do
  include OwnTestHelper

  let!(:brewery) { FactoryGirl.create :brewery, :name => "Koff" }
  let!(:beer1) { FactoryGirl.create :beer, :name => "iso 3", :brewery => brewery }
  let!(:beer2) { FactoryGirl.create :beer, :name => "Karhu", :brewery => brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in 'Pekka', 'foobar1'
  end

  it "is registered to the beer and user who is signed in when given" do
    visit new_rating_path
    select(beer1.to_s, :from => 'rating[beer_id]')
    fill_in('rating[score]', :with => '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "is deleted when the rater deletes it" do
    create_beer_with_rating 20, user, 'Lager'

    visit user_path(user)
    expect{click_link 'Delete'}.to change{Rating.count}.from(1).to(0)
  end
end