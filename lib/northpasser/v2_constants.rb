require 'json'
require 'csv'

module Northpasser
  V2_API_URL = "https://api.northpass.com/v2/".freeze

  # These are the resource for the northpass v2 api and can form part of the path
  V2_RESOURCES = [
    :activities,
    :assignment_submissions,
    :events,
    :people
  ].freeze
end
