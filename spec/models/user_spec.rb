require 'spec_helper'

describe User do
  include OwnTestHelper

  it "is not saved with a username too short" do
    user = User.create username: "gg"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved without a proper password" do
    user = User.create username: "Pekka",
                       password: "lettersonly",
                       password_confirmation: "lettersonly"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user.valid?).to be(true)
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the one rated if there is only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, :beer => beer, :user => user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      style = Style.create(name: 'Lager')
      create_beers_with_ratings 10, 20, 15, 7, 9, user, style
      best = create_beer_with_rating(25, user, Style.create(name: "Lager"))

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the rated beer if there is only one rating" do
      style = Style.create(name: "Lager")
      create_beer_with_rating(20, user, style)

      expect(user.favorite_style).to eq(style)
    end

    it "is the style with the highest average rating if several beers are rated" do
      stout = Style.create(name: "Stout")
      create_beers_with_ratings(10, 20, 15, 7, 9, user, Style.create(name: "Lager"))
      create_beers_with_ratings(10, 20, 15, 7, 50, user, stout)
      create_beers_with_ratings(10, 20, 15, 7, 30, user, Style.create(name: "Porter"))

      expect(user.favorite_style).to eq(stout)
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the rated beer if there is only one rating" do
      brewery = FactoryGirl.create(:brewery)
      brewery.beers << create_beer_with_rating(20, user, Style.create(name: 'Lager'))

      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the brewery with the highest average rating if several beers are rated" do
      brewery = FactoryGirl.create(:brewery)
      brewery2 = FactoryGirl.create(:brewery)
      brewery3 = FactoryGirl.create(:brewery)

      brewery.beers << create_beers_with_ratings(10, 20, 15, 7, 9, user, Style.create(name: "Lager"))
      brewery2.beers << create_beers_with_ratings(10, 20, 15, 7, 50, user, Style.create(name: "Stout"))
      brewery3.beers << create_beers_with_ratings(10, 20, 15, 7, 30, user, Style.create(name: "Porter"))

      expect(user.favorite_brewery).to eq(brewery2)
    end
  end
end