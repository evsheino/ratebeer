json.array!(@beers) do |beer|
  json.extract! beer, :name, :style, :brewery_id
  json.url beer_url(beer, format: :json)
end
