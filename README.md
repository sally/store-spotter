# StoreSpotter

```
   _____ __                 _____             __  __
  / ___// /_____  ________ / ___/____  ____  / /_/ /____  _____
  \__ \/ __/ __ \/ ___/ _ \\__ \/ __ \/ __ \/ __/ __/ _ \/ ___/
 ___/ / /_/ /_/ / /  /  __/__/ / /_/ / /_/ / /_/ /_/  __/ /
/____/\__/\____/_/   \___/____/ .___/\____/\__/\__/\___/_/
                              /_/
```

Welcome to StoreSpotter, a simple command-line tool for finding the nearest retail store.

## How It Works

The stores in the CSV file were imported into a PostgreSQL database, where each data field (e.g. City, State, Longitude, Latitude, etc.) were stored as column entries. I then used ActiveRecord for object-relational mapping to easily access all of the stores in the Ruby source code.

Given an input address that is reasonably well-formatted, we retrieve further details of the location using geocoding and check great circle distances against each Store object using [Haversine's formula](https://en.wikipedia.org/wiki/Haversine_formula) and lat/lng coordinates. The store with the least Haversine distance from the input address is returned.

Some key Ruby libraries I used were [Geocoder](https://github.com/alexreisner/geocoder) and [Haversine](https://github.com/kristianmandrup/haversine). The former was to retrieve location information (including county and lat/lng) for an input address, and the latter was to accurately calculate great-circle distance between two points (i.e. shortest distance over the earth's surface) given the lat/lng coordinates of the respective points.

## Local Usage

To run StoreSpotter locally, please download the files, install the Bundler gem to retrieve all dependencies, set up the database, then execute `storespotter.rb`:

1. [Download](https://github.com/parkyngj/geo-challenge/archive/master.zip) the files
2. Run `gem install bundler` to install the Bundler gem manager
3. Run `bundle install` to install dependencies
4. Run `rake db:setup` to set up the database
5. Run `ruby storespotter.rb` to initiate StoreSpotter

----

## Notes

Here are some tidbits that I felt compelled to write regarding my process in completing the challenge. Feel free to read them. I had a lot of fun!

### Refined, But Broken

Previously, I had implemented a version of my project where I attempted to narrow down possible store matches by refining the entire list of stores to just stores belonging to the same zip code as the input address, then the same city, then county, ... etc.

However, I realized that this approach may actually return inaccurate information regarding what is the "closest store." Consider the following situation:

A store and the input address are on opposite ends of the zip code region that they belong to. However, there is a store across the street from the input address, which just happens to be in an adjacent zip code region. The approach above would return the store farther away anyway, because of the happenstance of the two locations in question being in the same zip code.

Could there be other ways to narrow down the possible stores to iterate through and check Haversine distances against? Perhaps filtering by the zip/city/county/state that an input address belongs to is too strict. We could instead filter by, for example, zip code + all adjacent zip codes. Another idea is to filter by zip codes within a certain radius of the location.

Either way, I'd probably need to use more machinery in terms of API integration to find zips/cities/counties/states within a certain radius of a given location. I'm sure I could use the Google Maps API to do this, although [ZipCodeAPI](https://www.zipcodeapi.com/API) and [FreeMapTools](https://www.freemaptools.com/find-zip-codes-inside-radius.htm) also looked promising.

Some old notes that were featured on this README from the reign of the previous implementation can be found [here]()

### Haversine VS Navigable Distance

It's true that the program returns the "closest store" in terms of great circle distance. However, this may not actually correspond to real distance that can be travelled by a human, due to construction, one-way streets, invisible forcefields, etc. (just kidding about that last one).

If I were to rectify this, next steps would be additional integration of an API that calculates shortest navigable routes between one location and another - and use these distances instead of Haversine distances to return the closest store.
