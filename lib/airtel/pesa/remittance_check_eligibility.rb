# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'
require 'ostruct'
require 'json'

module Airtel
  module Pesa
    class RemittanceCheckEligibility
      STAGING_URL = "https://openapiuat.airtel.africa".freeze
      PRODUCTION_URL = "https://openapi.airtel.africa".freeze

      attr_reader :amount, :phone_number, :country, :currency_code

      def self.call(amount:, phone_number:, country:, currency_code:)
        new(amount, phone_number, country, currency_code).call
      end
  
      def initialize(amount, phone_number, country, currency_code)
        @amount = amount
        @phone_number = phone_number
        @country = country
        @currency_code = currency_code
      end

      def call
        url = URI("#{env_url}/openapi/moneytransfer/v2/validate")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["Content-Type"] = 'application/json'
        request["Authorization"] = "Bearer #{token}"
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
          "amount": amount,
          "country": country,
          "currency": currency_code,
          "msisdn": phone_number
        }
      end
    end
  end
end
