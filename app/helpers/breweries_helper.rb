module BreweriesHelper
  def cache_key_for_breweries
    count = Brewery.count
    max_updated_at = Brewery.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "breweries/all-#{count}-#{max_updated_at}"
  end
end
