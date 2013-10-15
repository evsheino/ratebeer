module BeersHelper
  def cache_key_for_beers(order)
    count = Beer.count
    max_updated_at = Beer.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "beers/all-#{count}-#{max_updated_at}-#{order}"
  end
end
