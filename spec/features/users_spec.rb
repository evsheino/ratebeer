require 'spec_helper'

describe "User" do
  include OwnTestHelper

  let!(:user) { FactoryGirl.create :user }

  describe "who has signed up" do
    it "can sign in with the right credentials" do
      sign_in 'Pekka', 'foobar1'

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to the sign in form if wrong credentials are given" do
      sign_in 'Pekka', 'wrong'

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and password do not match!'
    end

    it "has a favorite style on his/her page" do
      sign_in 'Pekka', 'foobar1'

      create_beer_with_rating(20, user, Style.create(name: 'Lager'))
      create_beer_with_rating(19, user, Style.create(name: 'Porter'))
      visit user_path(user)

      expect(page).to have_content 'Favorite style is Lager'
    end

    it "has a favorite brewery on his/her page" do
      sign_in 'Pekka', 'foobar1'
      create_beer_with_rating 20, user, FactoryGirl.create(:style)
      visit user_path(user)

      expect(page).to have_content 'favorite brewery is anonymous'
    end
  end

  it "is added to the system after signing up with good credentials" do
    visit signup_path
    fill_in('user_username', :with => 'Brian')
    fill_in('user_password', :with => 'secret55')
    fill_in('user_password_confirmation', :with => 'secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end
end