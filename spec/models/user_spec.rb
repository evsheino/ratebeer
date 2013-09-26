require 'spec_helper'

describe User do
  it "is not saved with a username too short" do
    user = User.create username: "gg"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not save without a password" do
    user = User.create username: "Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not save without a proper password" do
    user = User.create username: "Pekka",
                       password: "lettersonly",
                       password_confirmation: "lettersonly"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ User.create :username => "Pekka", :password => "secret1", :password_confirmation => "secret1" }

    it "is saved" do
      expect(user.valid?).to be(true)
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      rating1 = Rating.new :score => 10
      rating2 = Rating.new :score => 20

      user.ratings << rating1
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end