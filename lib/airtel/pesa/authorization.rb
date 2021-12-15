# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'
require 'ostruct'
require 'json'

module Airtel
  module Pesa
    class Authorization
      def initialize; end

      def self.call
        url = URI("https://openapiuat.airtel.africa/auth/oauth2/token")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["Content-Type"] = 'application/json'
        request.body = JSON.dump(body)

        response = http.request(request)
        parsed_body = JSON.parse(response.read_body)

        result = OpenStruct.new(
          access_token: parsed_body["access_token"],
          expires_in: parsed_body["expires_in"],
          token_type: parsed_body["token_type"]
        )
        OpenStruct.new(result: result, error: nil)
      rescue JSON::ParserError => error
        OpenStruct.new(result: nil, error: error)
      end

      private

      def body
        {
          "client_id": Airtel::Pesa.configuration.client_id,
          "client_secret": Airtel::Pesa.configuration.client_secret,
          "grant_type": "client_credentials"
        }
      end
    end
  end
end
