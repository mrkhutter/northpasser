require "northpasser/version"
require "northpasser/v1/constants"
require "northpasser/v1/path_builder"
require "northpasser/v1/request"

module Northpasser
  class Northpass
    include V1::PathBuilder

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
      !token.nil? && V1::FORMATS.keys.include?(response_format)
    end
  end
end
