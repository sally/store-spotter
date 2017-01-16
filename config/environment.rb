# Library to handle Uniform Resource Identifiers for connecting to PostgreSQL database
require 'uri'

# Library for locating files in file system
require 'pathname'

# Library to provide interface for CSV files/data
require 'csv'

# Set up gems listed in the Gemfile
# See: http://gembundler.com/bundler_setup.html
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

# Set up gems listed in Gemfile
require 'rubygems'
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

require 'pg'
require 'active_record'
require 'rake'
require 'geocoder'

# Helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s

# Set up controllers, helpers, views
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'views', '*.rb')].each { |file| require file }

# Set up custom-written libraries
Dir[APP_ROOT.join('lib', '*.rb')].each { |file| require file }

# Set up the database and models
require APP_ROOT.join('config', 'database')
