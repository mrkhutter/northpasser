$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dotenv'
require 'json'
require 'simplecov'
require 'webmock/rspec'
SimpleCov.start

# Loads the contents of .env into ENV
# https://github.com/bkeepers/dotenv
Dotenv.load

require 'northpasser'
