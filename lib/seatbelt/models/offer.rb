module Seatbelt
  module Models
    # Public: Abstraction of Travel-It offer page element.
    class Offer
      include Seatbelt::Ghost
      include Seatbelt::Document

      # TravelIt Node: PREIS
      attribute :price,             Float
      # TravelIt Node: LCODE
      attribute :lcode,             String
      # TravelIt Node: LNAME
      attribute :lname,             String
      # TravelIt Node: GIDD
      attribute :gidd,              String
      # TravelIt Node: TAGE
      attribute :travel_days,       Integer
      # TravelIt Node: VT
      attribute :catering,          String
      # TravelIt Node: ZT
      attribute :room_type,         String
      # TravelIt Node: LUFTTEMP
      attribute :air_temperature,   Float
      # TravelIt Node: WASSERTEMP
      attribute :water_temperature, Float
      # TravelIt Node: FLUGZEIT
      attribute :flight_duration,   Integer
      # TravelIt Node: BEWERTUNG
      attribute :rating,            Integer
      # TravelIt Node: ANZBEWERTUNG
      attribute :rating_count,      Integer

    end
  end
end