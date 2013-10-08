require 'spec_helper'

describe "Beer" do
  include OwnTestHelper

  let!(:brewery) { FactoryGirl.create :brewery, :name => "Koff" }
  let!(:style) { FactoryGirl.create :style }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in 'Pekka', 'foobar1'
  end

  it "is added to the database when a user creates one" do
    visit new_beer_path
    select(brewery.to_s, :from => 'beer[brewery_id]')
    select(style.to_s, :from => 'beer[style_id]')
    fill_in('beer[name]', :with => 'Kolmonen')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end
end