# frozen_string_literal: true

require 'openssl'
require 'ostruct'
require 'base64'

module Airtel
  module Pesa
    class PinEncryption
      def initialize; end

      def self.call
        string = '3333';
        public_key = OpenSSL::PKey::RSA.new(Base64.decode64(key))
        encrypted_string = Base64.encode64(public_key.public_encrypt(string))

        OpenStruct.new(result: encrypted_string, error: nil)
      end

      private

      def key
        "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCkq3XbDI1s8Lu7SpUBP+bqOs/MC6PKWz6n/0UkqTiOZqKqaoZClI3BUDTrSIJsrN1Qx7ivBzsaAYfsB0CygSSWay4iyUcnMVEDrNVOJwtWvHxpyWJC5RfKBrweW9b8klFa/CfKRtkK730apy0Kxjg+7fF0tB4O3Ic9Gxuv4pFkbQIDAQAB"
      end
    end
  end
end
