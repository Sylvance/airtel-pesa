# frozen_string_literal: true
require 'ostruct'

require_relative "pesa/account_balance_enquiry"
require_relative "pesa/authorization"
require_relative "pesa/collections_refund_payment"
require_relative "pesa/collections_transaction_enquiry"
require_relative "pesa/collections_ussd_push_payment"
require_relative "pesa/constants"
require_relative "pesa/disbursement_payment"
require_relative "pesa/disbursement_transaction_enquiry"
require_relative "pesa/encryption_pin"
require_relative "pesa/kyc_user_enquiry"
require_relative "pesa/remittance_check_eligibility"
require_relative "pesa/remittance_money_refund"
require_relative "pesa/remittance_money_transfer_credit"
require_relative "pesa/remittance_money_transfer_status"
require_relative "pesa/version"

module Airtel
  module Pesa
    class Error < StandardError; end

    def self.configuration
      @configuration ||= OpenStruct.new(
        client_id: nil,
        client_secret: nil,
        pass_key: nil,
        short_code: nil,
        response_type: nil,
        callback_url: nil,
        result_url: nil,
        queue_time_out_url: nil,
        default_description: nil,
        enviroment: nil
      )
    end

    def self.configure
      yield(configuration)
    end

    def to_recursive_ostruct(hash)
      result = hash.each_with_object({}) do |(key, val), memo|
          memo[key] = val.is_a?(Hash) ? to_recursive_ostruct(val) : val
      end

      OpenStruct.new(result)
    end
  end
end
