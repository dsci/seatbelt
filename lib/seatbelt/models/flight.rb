module Seatbelt
  module Models
    # Public: Abstraction of Travel-It Region page element.
    class Flight
      include Seatbelt::Ghost
      include Seatbelt::Document

      # TravelIt Node: RUECK
      attribute :day_of_unbound_flight,       String
      # TravelIt Node: HIN
      attribute :day_of_return_flight,        String
      # TravelIt Node: TERMIN
      attribute :return_flight_at,            Date
      # TravelIt Node: RRTAG
      attribute :outbound_flight_at,          Date
      # TravelIt Node: TAGE
      attribute :trip_length,                 Integer
      # TravelIt Node: ZIEL
      attribute :destination,                 String
      # TravelIt Node: PREIS
      attribute :price_per_person,            Float
      # TravelIt Node: GPREIS
      attribute :overall_journey_price,       Float
      # TravelIt Node: REF
      attribute :ref,                         String
      # TravelIt Node: LC
      attribute :lc,                          String
      # TravelIt Node: REISEART
      attribute :travel_type,                 String
      # TravelIt Node: HINFLUG (maybe a list of times)
      attribute :duration_of_outbound_flight, Integer
      # TravelIt Node: RUECKFLUG (maybe a list of times)
      attribute :duration_of_return_flight,   Integer
      # TravelIt Node: RUECKFLUGCODE
      attribute :outbound_flight_code,        String
      # TravelIt Node: HINFLUGCODE
      attribute :return_flight_code,          String
    end
  end
end