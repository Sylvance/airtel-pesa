# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'
require 'ostruct'
require 'json'

module Airtel
  module Pesa
    class RemittanceMoneyTransferCredit
      STAGING_URL = "https://openapiuat.airtel.africa".freeze
      PRODUCTION_URL = "https://openapi.airtel.africa".freeze

      attr_reader :amount, :country, :currency_code, :external_transaction_id,
                  :phone_number, :payer_country_code, :payer_first_name, :payer_last_name,
                  :pin

      def self.call(
        amount:, country:, currency_code:, external_transaction_id:,
        phone_number:, payer_country_code:, payer_first_name:, payer_last_name:, pin:
      )
        new(
          amount, country, currency_code, external_transaction_id,
          phone_number, payer_country_code, payer_first_name, payer_last_name, pin
        ).call
      end
  
      def initialize(
        amount, country, currency_code, external_transaction_id,
        phone_number, payer_country_code, payer_first_name, payer_last_name, pin
      )
        @amount = amount
        @country = country
        @currency_code = currency_code
        @external_transaction_id = external_transaction_id
        @phone_number = phone_number
        @payer_country_code = payer_country_code
        @payer_first_name = payer_first_name
        @payer_last_name = payer_last_name
        @pin = pin
      end

      def call
        url = URI("#{env_url}/openapi/moneytransfer/v2/credit")

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
          "extTRID": external_transaction_id,
          "msisdn": phone_number,
          "payerCountry": payer_country_code,
          "payerFirstName": payer_first_name,
          "payerLastName": payer_last_name,
          "pin": pin || Airtel::Pesa::PinEncryption.call.result
        }
      end
    end
  end
end
