module Seatbelt
  module Models

    # Public: Abstraction of Travel-It offer page element.
    class Offer
      include Seatbelt::Document


      # Type of travel - Symbol (:package, :hotel_only, :flight_only)
      attribute :type_of_travel,            Symbol
      # departure date with lowest price
      attribute :departure_date,            Date
      # days of travel
      attribute :days,                      Integer
      # tour operator
      attribute :operator,                  String
      # hotel giata id
      attribute :hotel_gid,                 Integer
      # hotel giata object code
      attribute :hotel_goc,                 String
      # hotel 3letter code
      attribute :hotel_dlc,                 String
      # hotel foreign id
      attribute :hotel_fid,                 String
      # hotel reference number
      attribute :hotel_ref,                 Integer
      # hotel category (0..7), not stars!
      attribute :hotel_cat,                 Integer
      # hotel name
      attribute :hotel_name,                String  # f.e. "Safarie Park"
      # hotel giata id
      attribute :city_gid,                  Integer
      # region name
      attribute :city_name,                 String  # f.e. "Sa Coma"
      # region name
      attribute :region_name,               String  # f.e. "Balearen"
      # destination name
      attribute :destination_name,          String  # f.e. "Mallorca"

      # departure airport with lowest price
      attribute :departure_airport_code,    String

      # lowest price when grouping is used
      attribute :price,                     Float
      # overnight price
      attribute :on_price,                  Float
      # breakfast price
      attribute :bf_price,                  Float
      # halfboard price
      attribute :hb_price,                  Float
      # fullboard price
      attribute :fb_price,                  Float
      # all-inclusive price
      attribute :ai_price,                  Float

      # lowest entire price when grouping is used
      attribute :entire_price,              Float
      # overnight entire price
      attribute :on_entire_price,           Float
      # breakfast entire price
      attribute :bf_entire_price,           Float
      # halfboard entire price
      attribute :hb_entire_price,           Float
      # fullboard entire price
      attribute :fb_entire_price,           Float
      # all-inclusive entire price
      attribute :ai_entire_price,           Float

      # distance to beach in meters
      attribute :distance_to_beach,         Integer
      # average water temperature during travel time
      attribute :water_temperature,         Integer
      # average air temperature during travel time
      attribute :air_temperature,           Integer

      # Call reviews with  http://www.lmplus.popup.holidaycheck.com/hc_[HCID].html
      # holiday check id of the hotel
      attribute :hotel_hcid,                Integer
      # number of hotel reviews
      attribute :hotel_reviews,             Integer # f.e. 240
      # hotel Rating 
      attribute :hotel_rating,              Float  # f.e. 5.1
      # hotel recommendation rate
      attribute :hotel_recommendation_rate, Float  # f.e. 96.0

      # Attribute for implementation specifc attributes
      attribute :internals,                 Hash


      # Public: Virtual attribute lowest price
      #
      # Returns Float or nil if no price available
      def lowest_price
        [ price, on_price, bf_price, hb_price, fb_price, ai_price ].compact.min
      end


      # Public: Virtual attribute lowest entire price
      #
      # Returns Float or nil if no entire price available
      def lowest_entire_price
        [ entire_price,
          on_entire_price,
          bf_entire_price,
          hb_entire_price,
          fb_entire_price,
          ai_entire_price ].compact.min
      end
    end

  end
end