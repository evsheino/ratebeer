require 'spec_helper'

describe "Ratings page" do
  include OwnTestHelper

  it "should not have any ratings if none have been given" do
    visit ratings_path
    expect(page).to have_content 'List of ratings'
    expect(page).to have_content 'Total number of ratings: 0'
  end

  describe "when ratings exists" do
    it "lists the ratings and their total number" do
      user = FactoryGirl.create(:user)
      ratings = [20, 30, 25, 40]
      ratings.each do |rating|
        create_beer_with_rating(rating, user, Style.create(name: 'Lager'))
      end
      visit ratings_path
      expect(page).to have_content "Total number of ratings: 4"
      ratings.each do |rating|
        expect(page).to have_content rating
      end
    end
  end
end