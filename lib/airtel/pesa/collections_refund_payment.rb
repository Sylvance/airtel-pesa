# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'
require 'ostruct'
require 'json'

module Airtel
  module Pesa
    class CollectionsRefundPayment
      STAGING_URL = "https://openapiuat.airtel.africa".freeze
      PRODUCTION_URL = "https://openapi.airtel.africa".freeze

      attr_reader :airtel_money_id, :transaction_country_code, :transaction_currency_code

      def self.call(airtel_money_id:, transaction_country_code:, transaction_currency_code:)
        new(airtel_money_id, transaction_country_code, transaction_currency_code).call
      end
  
      def initialize(airtel_money_id, transaction_country_code, transaction_currency_code)
        @airtel_money_id = airtel_money_id
        @transaction_country_code = transaction_country_code
        @transaction_currency_code = transaction_currency_code
      end
  
      def call
        url = URI("#{env_url}/standard/v1/payments/refund")

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
        {
          "transaction": {
            "airtel_money_id": airtel_money_id
          }
        }
      end
    end
  end
end
