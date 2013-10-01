require 'spec_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the places page" do
    BeermappingAPI.stub(:places_in).with('kumpula').and_return([Place.new(:name => 'Oljenkorsi')])

    visit places_path
    fill_in('city', :with => 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned by the API, they are shown at the places page" do
    BeermappingAPI.stub(:places_in).with('katajanokka').and_return([Place.new(:name => 'Poseidon'),
                                                                Place.new(:name => 'Katajanmarja')])

    visit places_path
    fill_in('city', :with => 'katajanokka')
    click_button "Search"

    expect(page).to have_content 'Poseidon'
    expect(page).to have_content 'Katajanmarja'
  end

  it "if nothing is returned by the API, no places are shown at the places page" do
    BeermappingAPI.stub(:places_in).with('kallio').and_return([])

    visit places_path
    fill_in('city', :with => 'kallio')
    click_button "Search"

    expect(page).to have_content 'No locations in kallio'
  end
end