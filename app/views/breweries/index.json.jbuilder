json.array!(@breweries) do |brewery|
  json.extract! brewery, :name, :year
  json.url brewery_url(brewery, format: :json)
end
