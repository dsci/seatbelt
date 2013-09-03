module Seatbelt
  module Models

    # Public: Abstraction of Airport page element.
    class Airport
      include Seatbelt::Ghost
      include Seatbelt::Document

      # ident code
      attribute :ident,             String
      # Three Letter Code
      attribute :iata_code,         String
      # type
      attribute :type,              String
      # name
      attribute :name,              String
      # Two letter country code 
      attribute :lcode,             String      
      # Coordinate Latitude
      attribute :latitude,          Float
      # Coordinate Longitude
      attribute :longitude,         Float
      # GPS Code
      attribute :gps_code,          String
      # Scheduled Service
      attribute :scheduled_service, Boolean
      # Website
      attribute :home_link,         String
      #WIKI Page
      attribute :wikipedia_link,    String
    end
  end
end