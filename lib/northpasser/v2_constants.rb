require 'json'
require 'csv'

module Northpasser
  V1_API_URL = "https://api.northpass.com/v1/".freeze

  # These are the resource for the northpass v2 api and can form part of the path
  RESOURCES = [
    :activities,
    :assignment_submissions,
    :events,
    :people
  ].freeze
end
