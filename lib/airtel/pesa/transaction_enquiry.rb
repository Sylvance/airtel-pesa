# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'
require 'ostruct'
require 'json'

module Airtel
  module Pesa
    class TransactionEnquiry
      STAGING_URL = "https://openapiuat.airtel.africa".freeze
      PRODUCTION_URL = "https://openapi.airtel.africa".freeze

      attr_reader :transaction_id, :transaction_country_code, :transaction_currency_code

      def self.call(transaction_id:, transaction_country_code:, transaction_currency_code:)
        new(transaction_id, transaction_country_code, transaction_currency_code).call
      end

      def initialize(transaction_id, transaction_country_code, transaction_currency_code)
        @transaction_id = transaction_id
        @transaction_country_code = transaction_country_code
        @transaction_currency_code = transaction_currency_code
      end
  
      def call
        url = URI("#{env_url}/standard/v1/payments/#{transaction_id}")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(url)
        request["Authorization"] = "Bearer #{token}"
        request["X-Country"] = transaction_country_code
        request["X-Currency"] = transaction_currency_code

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
    end
  end
end
