users = 1000
breweries = 500
beers_in_brewery = 500
ratings_per_user = 300

(1..users).each do |i|
  User.create :username => "user_#{i}", :password => "passwd1", :password_confirmation => "passwd1"
end

(1..breweries).each do |i|
  Brewery.create :name => "brewery_#{i}", :year => 1900, :active => true
end

bulk = Style.create :name => "bulk", :description => "cheap, not much taste"

Brewery.all.each do |b|
  n = rand(beers_in_brewery)
  (1..n).each do |i|
    beer = Beer.create :name => "beer #{b.id} -- #{i}"
    beer.style = bulk
    b.beers << beer
  end
end

User.all.each do |u|
  n = rand(ratings_per_user)
  beers = Beer.all.shuffle
  (1..n).each do |i|
    r = Rating.new :score => (1+rand(50))
    beers[i].ratings << r
    u.ratings << r
  end
end
