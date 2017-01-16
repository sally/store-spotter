class StoreHelper

  @@filters = ["zip_code", "city", "county", "state"]

  def find_store(input_address)
    @input_address = GeocoderService.address_info(Geocoder.search(input_address))
    get_closest(filter_stores)
  end

  private

  def filter_stores
    @@filters.each do |filter|
      stores = Store.where("#{filter} ~* ? AND state ~* ?",
                           "(#{@input_address[filter]}.*)",
                           "(#{@input_address['state']}.*)")
      return stores if !stores.empty?
    end

    Store.all
  end

  def get_closest(store_candidates)
    input_coords = [@input_address['lat'], @input_address['lng']]
    closest_store = store_candidates.first
    closest_distance = Haversine.distance(input_coords,
                                          [closest_store.latitude, closest_store.longitude].map(&:to_f)
                                          ).to_miles

    store_candidates.each do |store|
      distance = Haversine.distance(input_coords,
                                    [store.latitude, store.longitude].map(&:to_f)
                                    ).to_miles
      if closest_distance > distance
        closest_store = store
        closest_distance = distance
      end
    end

    closest_store
  end

end
