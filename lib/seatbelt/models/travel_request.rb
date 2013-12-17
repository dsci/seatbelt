module Seatbelt
  module Models
   
    # Public: Abstraction of Travel-It travel request.
    class TravelRequest
      include Seatbelt::Ghost
      include Seatbelt::Document

      interface :instance do
        # Number of adults - Integer
        define :number_of_adults
        define :number_of_adults=, args: [:val]

        # Type of travel - Symbol (:package, :hotel_only, :flight_only)
        define :type_of_travel
        define :type_of_travel=, args: [:val]

        # Departure date - Date
        define :departure_date
        define :departure_date=, args: [:val]

        # Return date - Date
        define :return_date
        define :return_date=, args: [:val]

        # Minimum number of travel days - Integer
        define :min_days_of_travel
        define :min_days_of_travel=, args: [:val]

        # Maximum number of travel days - Integer
        define :max_days_of_travel
        define :max_days_of_travel=, args: [:val]


        # Others #
        #--------#

        # Offers grouping - Symbol (:none, :hotel, :hotel_per_operator)
        define :group_by
        define :group_by=, args: [:val]

        # Offers to skip in case there are more offers available - Integer
        define :skip
        define :skip=, args: [:val]

        # Number of offers to return - Integer
        define :limit
        define :limit=, args: [:val]

        # Offers sorting - Symbol
        # ( :price, :operator, :hotel_name, :hotel_city, :hotel_category,
        #   :hotel_rating, :hotel_recommendation_rate )
        #
        # Append '_asc'  to sort ascending  (f.e. :price_asc)
        # Append '_desc' to sort descending (f.e. :price_desc)
        define :sort_by
        define :sort_by=, args: [:val]


        # Finds offers by selfs attributes
        #
        # Returns Seatbelt::Models::TravelResponse or nil
        define :find_offers
      end

    end

  end
end