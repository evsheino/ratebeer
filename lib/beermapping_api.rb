module BeermappingAPI

  LOCQUERY_SERVICE = 'locquery'
  LOCCITY_SERVICE = 'loccity'

  def self.places_in(city)
    Place
    city = city.downcase

    cache_city(city) unless Rails.cache.exist?(city)

    Rails.cache.read city
  end

  def self.place(place_id)
    Rails.cache.write(place_id, fetch_place(place_id)) unless Rails.cache.exist?(place_id)

    Rails.cache.read(place_id)
  end

  private

    def self.cache_city(city)
      places = fetch_places_in(city)
      Rails.cache.write(city, places)

      places.each do |place|
        Rails.cache.write(place.id, place) unless Rails.cache.exist?(place.id)
      end
    end

    def self.fetch_place(place_id)
      fetch_places(LOCQUERY_SERVICE, place_id).first
    end

    def self.fetch_places_in(city)
      fetch_places(LOCCITY_SERVICE, city)
    end

    def self.fetch_places(service, query)
      url = "http://beermapping.com/webservice/#{service}/#{key}/"

      response = HTTParty.get "#{url}#{query.to_s.gsub(' ', '%20')}"
      places = response.parsed_response["bmp_locations"]["location"]

      return [] if places.is_a?(Hash) and places['id'].nil?

      places = [places] if places.is_a?(Hash)
      places.inject([]) do | set, place |
        set << Place.new(place)
      end
    end

    def self.key
      Settings.beermapping_apikey
    end
end