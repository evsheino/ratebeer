require 'spec_helper'

describe "Beerlist page" do
  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(:allow_localhost => true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, :name => "Koff")
    @brewery2 = FactoryGirl.create(:brewery, :name => "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, :name => "Ayinger")
    @style1 = Style.create :name=>"Lager"
    @style2 = Style.create :name=>"Rauchbier"
    @style3 = Style.create :name=>"Weizen"
    @beer1 = FactoryGirl.create(:beer, :name => "Nikolai", :brewery => @brewery1, :style => @style1)
    @beer2 = FactoryGirl.create(:beer, :name => "Fastenbier", :brewery => @brewery2, :style => @style2)
    @beer3 = FactoryGirl.create(:beer, :name => "Lechte Weisse", :brewery => @brewery3, :style => @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows a known beer", :js => true do
    visit beerlist_path
    expect(page).to have_content "Nikolai"
  end

  it "shows the beers in alphabetical order at first", :js => true do
    visit beerlist_path
    check_order(['Fastenbier', 'Lechte Weisse', 'Nikolai'])
  end

  it "shows the beers in style order after sorting by style", :js => true do
    visit beerlist_path
    click_link 'Style'
    check_order(['Lager', 'Rauchbier', 'Weizen'])
  end

  it "shows the beers in brewery order after sorting by brewery", :js => true do
    visit beerlist_path
    click_link 'Brewery'
    check_order(['Ayinger', 'Koff', 'Schlenkerla'])
  end

  def check_order(list)
    i = 2
    list.each  do |item|
      find('table').find("tr:nth-child(#{i})").should have_content("#{item}")
      i += 1
    end
  end
end
