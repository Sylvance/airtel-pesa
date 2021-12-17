# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'
require 'ostruct'
require 'json'

module Airtel
  module Pesa
    class Example
      STAGING_URL = "https://openapiuat.airtel.africa".freeze
      PRODUCTION_URL = "https://openapi.airtel.africa".freeze

      attr_reader :param1, :transaction_country_code, :transaction_currency_code, :param4, :param5, :param6

      def self.call(param1:, transaction_country_code:, transaction_currency_code:, param4:, param5:, param6:)
        new(param1, transaction_country_code, transaction_currency_code, param4, param5, param6).call
      end
  
      def initialize(param1, transaction_country_code, transaction_currency_code, param4, param5, param6)
        @param1 = param1
        @transaction_country_code = transaction_country_code
        @transaction_currency_code = transaction_currency_code
        @param4 = param4
        @param5 = param5
        @param6 = param6
      end
  
      def call
        url = URI("#{env_url}/merchant/v1/payments/")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["Content-Type"] = 'application/json'
        request["Authorization"] = "Bearer #{token}"
        request["X-Country"] = transaction_country_code
        request["X-Currency"] = transaction_currency_code
        request.body = JSON.dump(body)

        response = http.request(request)
        parsed_response = JSON.parse(response.read_body)
        result = Airtel::Pesa.to_recursive_ostruct(parsed_response)
        OpenStruct.new(result: result, error: nil)
      rescue JSON::ParserError => error
        OpenStruct.new(result: nil, error: error)
      end

      private

      def env_url
        return STAGING_URL Airtel::Pesa.configuration.env == 'staging'
        return PRODUCTION_URL Airtel::Pesa.configuration.env == 'production'
      end

      def token
        Airtel::Pesa::Authorization.call.result.access_token
      end

      def body
        {}
      end
    end
  end
end
