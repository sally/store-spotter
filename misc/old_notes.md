# Old Notes From Previous Implementation

Here are some old notes that were featured on the README from the reign of the previous efficient, but inaccurate solution before its exposure.

## About Solution

My primary focus in completing this project was achieving time efficiency in querying the database of stores that I created from the CSV file.

The rough idea is that, given an address, the program will attempt to refine the entire list of ~1800 stores to a much shorter list to iterate through and check distances against by finding stores in the immediate proximity of the input address.

More specifically, if I enter `633 Folsom St, San Francisco, CA 94107`, the program will look for all stores with the zip code `94107` and find the one closest to the input using [Haversine's formula](https://en.wikipedia.org/wiki/Haversine_formula) and lat/lng coordinates. If there are no stores with that zip code, it will relax its search to stores in the city `San Francisco`, and determine the nearest one. If there are no stores in that city, it will relax its search further to stores in the county `San Francisco County`, ... etc. The bulk of this process can be seen automated [here](https://github.com/parkyngj/geo-challenge/blob/master/app/helpers/store_helper.rb).

## Remarks

Here are some optional tidbits to read about my process in completing the challenge when I had this implementation in mind.

### Burlington

I'd like to document a bug that I found and resolved shortly after writing this README.

I noticed that there are no stores in VT (Vermont) in the store locations CSV file. Curious to see what would happen, I looked up the first random VT address I could find: `S Prospect St, Burlington, VT 05405`. I expected to get something in one of its neighboring states, which are New York and New Hampshire. Instead, I got:

```
Burlington
NWC NJ Trnpk & Rte 541
2703 Route 541
Burlington, NJ 08016-4175
```

I immediately knew it was because I'd neglected to account for the fact that there are [many cities with the same name](https://en.wikipedia.org/wiki/List_of_the_most_common_U.S._place_names) in different states - as well as [counties](https://en.wikipedia.org/wiki/List_of_the_most_common_U.S._county_names).

To fix this, I found the query I was making to my database to narrow down stores by zip code, city, county, and state in that order:

```ruby
# using PostgreSQL case insensitive pattern matching to complete the filter
Store.where("#{filter} ~* ?",
            "(#{@input_address[filter]}.*)")
```

and modified it so that we'd be filtering by cities, counties in the same state if we didn't find any stores in the given zip code:

```ruby
Store.where("#{filter} ~* ? AND state ~* ?",
            "(#{@input_address[filter]}.*)",
            "(#{@input_address['state']}.*)")
```

It seems to have fixed the problem beautifully. Now when I ask StoreSpotter for `S Prospect St, Burlington, VT 05405`, I get:

```
Plattsburgh
NEC I-87 & State Hwy 3
60 Smithfield Blvd
Plattsburgh, NY 12901-2151
```

which is indeed the closest store, and also around 300 miles closer in driving distance than the previous result.

## Benchmarking

I was curious to know how much faster my sieving process (ballooning out from zip code -> city -> county -> state) for retrieving the closest store is (versus just iterating through every single store in the database).

I wrote a simple utility module to help benchmark my processes:

```ruby
module Benchmark

  def self.measure
    start_time = Time.now
    yield
    end_time = Time.now
    run_time = end_time - start_time
  end

end
```

and I added a method to the helper module that retrieves the closest store to find the closest store without filtering:

```ruby
def get_closest_store_no_filter
    input_coords = [@input_address['lat'], @input_address['lng']]
    closest_store = Store.all.first
    closest_distance = Haversine.distance(input_coords,
                                          [closest_store.latitude, closest_store.longitude].map(&:to_f)
                                          ).to_miles

    Store.all.each do |store| # Iterate through every store to check Haversine distances against
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
 ```

Using [this website](https://fakena.me/random-real-address/) to generate random valid U.S. addresses, I [benchmarked fifty results](https://docs.google.com/spreadsheets/d/1D33FpYXzKfzVD6iWTSNfltRSymQ3iNXoz6xE4j1DRPo/edit?usp=sharing) to discover that going through the filtering process averaged about 40% better runtime than not filtering.

This disparity would likely grow with the addition of more stores into the database.
