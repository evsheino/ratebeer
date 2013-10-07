module BeermappingAPI

  WEBSERVICE_URL = 'http://beermapping.com/webservice'
  LOCQUERY_SERVICE = 'locquery'
  LOCCITY_SERVICE = 'loccity'
  LOCSCORE_SERVICE = 'locscore'

  def self.places_in(city)
    Place
    city = city.downcase

    cache_city(city) unless Rails.cache.exist?(city)

    Rails.cache.read city
  end

  def self.place(place_id)
    return Rails.cache.read(place_id) if Rails.cache.exist?(place_id)

    place = Place.new(fetch_data(LOCQUERY_SERVICE, place_id).merge(fetch_scores(place_id)))

    Rails.cache.write(place_id, place)

    place
  end

  private

    def self.cache_city(city)
      places = fetch_places_in(city)
      Rails.cache.write(city, places)
    end

    def self.fetch_scores(place_id)
      fetch_data(LOCSCORE_SERVICE, place_id)
    end

    def self.fetch_place(place_id)
      fetch_places(LOCQUERY_SERVICE, place_id).first
    end

    def self.fetch_places_in(city)
      fetch_places(LOCCITY_SERVICE, city)
    end

    def self.fetch_data(service, query)
      return {} if query == '' || query.nil?

      url = "#{WEBSERVICE_URL}/#{service}/#{key}/"
      response = HTTParty.get "#{url}#{query.to_s.gsub(' ', '%20')}"

      response.parsed_response["bmp_locations"]["location"]
    end

    def self.fetch_places(service, query)
      places = fetch_data(service, query)

      return [] if places.is_a?(Hash) && places['id'].nil?

      places = [places] if places.is_a?(Hash)
      places.inject([]) do | set, place |
        set << Place.new(place)
      end
    end

    def self.key
      Settings.beermapping_apikey
    end
end