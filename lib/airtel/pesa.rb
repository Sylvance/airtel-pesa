# frozen_string_literal: true

require_relative "pesa/authorization"
require_relative "pesa/encryption"
require_relative "pesa/version"
require 'ostruct'

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
  end
end
