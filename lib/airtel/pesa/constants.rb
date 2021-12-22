# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'
require 'ostruct'
require 'json'

module Airtel
  module Pesa
    def self.find_country_by_name(name)
      constants.each do |country|
        country_class = "Airtel::Pesa::#{country}".constantize
        return as_struct(country_class) if country_class::COUNTRY == name.upcase
      end

      empty_struct
    end

    def self.as_struct(country_class)
      OpenStruct.new(
        currency_code: country_class::CURRENCY_CODE,
        country_code: country_class::COUNTRY_CODE,
        currency: country_class::CURRENCY,
        country: country_class::COUNTRY,
      )
    end

    def self.empty_struct
      OpenStruct.new(
        currency_code: nil,
        country_code: nil,
        currency: nil,
        country: nil,
      )
    end

    class UG
      CURRENCY = 'Ugandan shilling'
      CURRENCY_CODE = 'UGX'
      COUNTRY_CODE = 'UG'
      COUNTRY = 'UGANDA'
    end

    class NG
      CURRENCY = 'Nigerian naira'
      CURRENCY_CODE = 'NGN'
      COUNTRY_CODE = 'NG'
      COUNTRY = 'NIGERIA'
    end

    class TZ
      CURRENCY = 'Tanzanian shilling'
      CURRENCY_CODE = 'TZS'
      COUNTRY_CODE = 'TZ'
      COUNTRY = 'TANZANIA'
    end

    class KE
      CURRENCY = 'Kenyan shilling'
      CURRENCY_CODE = 'KES'
      COUNTRY_CODE = 'KE'
      COUNTRY = 'KENYA'
    end

    class RW
      CURRENCY = 'Rwandan franc'
      CURRENCY_CODE = 'RWF'
      COUNTRY_CODE = 'RW'
      COUNTRY = 'RWANDA'
    end

    class ZM
      CURRENCY = 'Zambian kwacha'
      CURRENCY_CODE = 'ZMW'
      COUNTRY_CODE = 'ZM'
      COUNTRY = 'ZAMBIA'
    end

    class GA
      CURRENCY = 'CFA franc BEAC'
      CURRENCY_CODE = 'CFA'
      COUNTRY_CODE = 'GA'
      COUNTRY = 'GABON'
    end

    class NE
      CURRENCY = 'CFA franc BCEAO'
      CURRENCY_CODE = 'XOF'
      COUNTRY_CODE = 'NE'
      COUNTRY = 'NIGER'
    end

    class CG
      CURRENCY = 'CFA franc BCEA'
      CURRENCY_CODE = 'XAF'
      COUNTRY_CODE = 'CG'
      COUNTRY = 'CONGO-BRAZZAVILLE'
    end

    class CD
      CURRENCY = 'Congolese franc'
      CURRENCY_CODE = 'CDF'
      COUNTRY_CODE = 'CD'
      COUNTRY = 'DR CONGO'
    end

    class CD_1
      CURRENCY = 'United States dollar'
      CURRENCY_CODE = 'USD'
      COUNTRY_CODE = 'CD'
      COUNTRY = 'DR CONGO'
    end

    class TD
      CURRENCY = 'CFA franc BEAC'
      CURRENCY_CODE = 'XAF'
      COUNTRY_CODE = 'TD'
      COUNTRY = 'CHAD'
    end

    class SC
      CURRENCY = 'Seychelles rupee'
      CURRENCY_CODE = 'SCR'
      COUNTRY_CODE = 'SC'
      COUNTRY = 'SEYCHELLES'
    end

    class MG
      CURRENCY = 'Malagasy ariary'
      CURRENCY_CODE = 'MGA'
      COUNTRY_CODE = 'MG'
      COUNTRY = 'MADAGASCAR'
    end

    class MW
      CURRENCY = 'Malawian kwacha'
      CURRENCY_CODE = 'MWK'
      COUNTRY_CODE = 'MW'
      COUNTRY = 'MALAWI'
    end
  end
end
