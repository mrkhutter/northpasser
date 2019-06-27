require "northpasser/version"
require "northpasser/versionless_constants"
require "northpasser/v1_constants"
require "northpasser/v2_constants"
require "northpasser/path_builder"
require "northpasser/request"

module Northpasser
  class Northpass
    include PathBuilder

    attr_accessor :token, :response_format

    # This is the basic object to interact with the northpass api. An api token
    # is required, and optionally the response format can be set.
    #
    def initialize(token, response_format: :json)
      raise ArgumentError unless input_valid?(token, response_format)

      self.token = token
      self.response_format = response_format
    end

    private

    def input_valid?(token, response_format)
      !token.nil? && FORMATS.keys.include?(response_format)
    end
  end
end
