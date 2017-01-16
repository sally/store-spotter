# StoreSpotter

*Under Construction: Still updating README*

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

My primary focus in completing this project was achieving time efficiency in querying the database of stores that I created from the CSV file.

The rough idea is that, given an address, the program will attempt to refine the entire list of ~1800 stores to a much shorter list to iterate through and check distances against by finding stores in the immediate proximity of the input address.

More specifically, if I enter `633 Folsom St, San Francisco, CA 94107`, the program will look for all stores with the zip code `94107` and find the one closest to the input using [Haversine's formuala](https://en.wikipedia.org/wiki/Haversine_formula) and lat/lng coordinates. If there are no stores with that zip code, it will relax its search to stores in the city `San Francisco`, and determine the nearest one. If there are no stores in that city, it will relax its search further to stores in the county `San Francisco County`, ... etc. The bulk of this process can be seen automated [here](https://github.com/parkyngj/geo-challenge/blob/master/app/helpers/store_helper.rb).

Some key Ruby libraries I used were [Geocoder](https://github.com/alexreisner/geocoder) and [Haversine](https://github.com/kristianmandrup/haversine). The former was to retrieve location information (including county and lat/lng) for an input address, and the latter was to accurately calculate great-circle distance between two points (i.e. shortest distance over the earth's surface) given the lat/lng coordinates of the respective points.

## Local Usage

To run StoreSpotter locally, please download the files, install the Bundler gem to retrieve all dependencies, set up the database, then execute `storespotter.rb`:

1. [Download](https://github.com/parkyngj/geo-challenge/archive/master.zip) the files
2. Run `gem install bundler` to install the Bundler gem manager
3. Run `bundle install` to install dependencies
4. Run `rake db:setup` to set up the database
5. Run `ruby storespotter.rb` to initiate StoreSpotter

----

#### Coding challenge

In this repo there is store-locations.csv

This is a tabular dataset of the locations of every store of a major national retail chain.

#### Deliverables

Please download the file (rather than forking this repo) and, do the exercise, and then upload to your own repo.

Then, write a script or application that, given a reasonably well-formed address string like:

1770 Union St, San Francisco, CA 94115

Returns the address of the geographically closest store from the dataset.

Also please write up a paragraph or two about how your solution works, any assumptions you made, or caveats about your implementation, and put it in this readme file.

Send me a github link to the final project.

#### Notes

Feel free to do this in whatever language you would like, and focus on the problem itself; the way data gets input into the program is not important. Command line, GUI application, or even editing an obvious variable at the top of a file. Whatever. As long as it's reasonably easy for me to run your code and there are clear instructions for doing so.

You might need to use external APIs or services to get a working solution. That's fine. Also fine to make it work entirely offline. To the extent you need any algorithms, I'm obviously not expecting you to reinvent anything from scratch, so use Google judiciously, as well as any libraries you find.

If you do add cool polish or go above an beyond in some way, feel free, but *by far the most important thing is delivering working software that solves the problem of finding the closest location of this store*.

I know which one is closest to my house, and the first thing I'll do is verify that it returns the address I expect.

I'm hoping this will take well under 2 hours; I did it in a language I know well and (with about 12 tabs open and tons of google searching) got a rough implementation working very quickly.

There are a ton of different ways to do this -- be creative!
