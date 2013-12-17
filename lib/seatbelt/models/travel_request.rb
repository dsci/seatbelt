module Seatbelt
  module Models
   
    # Public: Abstraction of Travel-It travel request.
    class TravelRequest
      include Seatbelt::Ghost
      include Seatbelt::Document

      interface :instance do
        # Number of adults - Integer
        define_property :number_of_adults

        # Type of travel - Symbol (:package, :hotel_only, :flight_only)
        define_property :type_of_travel

        # Departure date - Date
        define_property :departure_date

        # Return date - Date
        define_property :return_date

        # Minimum number of travel days - Integer
        define_property :min_days_of_travel

        # Maximum number of travel days - Integer
        define_property :max_days_of_travel


        # Others #
        #--------#

        # Offers grouping - Symbol (:none, :hotel, :hotel_per_operator)
        define_property :group_by

        # Offers to skip in case there are more offers available - Integer
        define_property :skip

        # Number of offers to return - Integer
        define_property :limit

        # Offers sorting - Symbol
        # ( :price, :operator, :hotel_name, :hotel_city, :hotel_category,
        #   :hotel_rating, :hotel_recommendation_rate )
        #
        # Append '_asc'  to sort ascending  (f.e. :price_asc)
        # Append '_desc' to sort descending (f.e. :price_desc)
        define_property :sort_by


        # Finds offers by selfs attributes
        #
        # Returns Seatbelt::Models::TravelResponse or nil
        define :find_offers
      end

    end

  end
end