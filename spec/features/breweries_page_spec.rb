require 'spec_helper'

describe "Breweries page" do
  it "should not have any breweries if none have been created" do
    visit breweries_path
    expect(page).to have_content 'Listing breweries'
    expect(page).to have_content 'Number of breweries: 0'
  end

  it "lists the existing breweries and their total number" do
    breweries = ["Koff", "Karjala", "Schlenkerla"]
    breweries.each do |brewery|
      FactoryGirl.create(:brewery, :name => brewery)
    end

    visit breweries_path

    expect(page).to have_content "Number of breweries: #{breweries.count}"

    breweries.each do |brewery|
      expect(page).to have_content brewery
    end
  end

  it "allows the user to navigate to the page of a brewery" do
    breweries = ["Koff", "Karjala", "Schlenkerla"]
    year = 1896
    breweries.each do |brewery|
      FactoryGirl.create(:brewery, :name => brewery, :year => year += 1)
    end

    visit breweries_path

    click_link "Koff"

    expect(page).to have_content "Koff"
    expect(page).to have_content "Established year 1897"
  end
end