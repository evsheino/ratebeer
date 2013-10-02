module BeermappingAPI

  def self.places_in(city)
    Place
    city = city.downcase
    Rails.cache.write(city, fetch_places_in(city)) unless Rails.cache.exist? city

    Rails.cache.read city
  end

  private

    def self.fetch_places_in(city)
      url = "http://beermapping.com/webservice/loccity/#{key}/"

      response = HTTParty.get "#{url}#{city.gsub(' ', '%20')}"
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