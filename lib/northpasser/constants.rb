require 'json'
require 'csv'

module Northpasser
  V1_API_URL = "https://api.northpass.com/v1/".freeze

  # Response formats the northpass api knows about
  FORMATS = {
    json: {
      headers: { header: 'Content-Type', content: 'application/json' },
      parser: JSON
    },
    csv: {
      headers: { header: 'Accept', content: 'text/csv' },
      parser: CSV
    }
  }.freeze

  # Action words are nice for our internal api and match the api path too
  ACTIONS = {
    get: :Get,
    update: :Put,
    delete: :Delete,
    list: :Get,
    create: :Post
  }.freeze

  # These are the resource for the northpass api and can form part of the path
  RESOURCES = [
    :assignments,
    :categories,
    :coupons,
    :courses,
    :groups,
    :learners,
    :memberships,
    :people,
    :quizzes
  ].freeze

  # These are the annoying edge cases in the northpass api that are don't fit
  EXCEPTIONS = {
    bulk_people: {
      path: "bulk/people",
      action: :Post
    },
    bulk_groups: {
      path: "bulk/groups",
      action: :Post
    }
  }.freeze
end
