class StoreHelper

  @@filters = ["zip_code", "city", "county", "state"]

  def find_store(input_address)
    @input_address = GeocoderService.address_info(Geocoder.search(input_address))
    @store_candidates = filter_stores
  end

  private

  def filter_stores
    @@filters.each do |filter|
      stores = Store.where("#{filter} ~* ?", "(#{@input_address[filter]}.*)")
      return stores if !stores.empty?
    end

    Store.all
  end

  

end
