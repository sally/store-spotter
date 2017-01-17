module GeocoderService

  def self.address_info(geocoder_search)
    return nil if geocoder_search.empty?
    
    info = {}

    geocoder_search[0].data["address_components"].each do |component|
      if component["types"][0] == "postal_code"
        info["zip_code"] = component["long_name"]
      elsif component["types"][0] == "locality"
        info["city"] = component["long_name"]
      elsif component["types"][0] == "administrative_area_level_2"
        info["county"] = component["long_name"]
      elsif component["types"][0] == "administrative_area_level_1"
        info["state"] = component["short_name"]
      end
    end

    info.merge(geocoder_search[0].data["geometry"]["location"])
  end

end
