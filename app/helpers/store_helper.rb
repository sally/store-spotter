class StoreHelper

  @@filters = ["zip_code", "city", "county", "state"]

  def find_store(input_address)
    @input_address = GeocoderService.address_info(Geocoder.search(input_address))
    @store_candidates = filter_stores
  end

  private

  

end
