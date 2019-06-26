require 'json'
require 'csv'

module Northpasser
  V1_API_URL = "https://api.northpass.com/v1/".freeze

  # These are the resource for the northpass v1 api and can form part of the path
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
