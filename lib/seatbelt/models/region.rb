module Seatbelt
  module Models

    # Public: Abstraction of Travel-It Region page element.
    class Region
      include Seatbelt::Ghost
      include Seatbelt::Document

      # TravelIt Node: NAME
      attribute :name,              String
      # No TravelIt Node given
      attribute :giata_id,          String
      # TravelIt Node: Ref
      # Three letter country code
      attribute :iso_code_country,  String
      # TravelIt Node: PREISE
      attribute :minimum_price,     Float
      # TravelIt Node: FLUGZEIT
      attribute :flight_duration,   Integer
      # TravelIt Node: LUFTTEMP
      attribute :air_temperature,   String
      # TravelIt Node: WASSERTEMP
      attribute :water_temperature, String

    end
  end
end