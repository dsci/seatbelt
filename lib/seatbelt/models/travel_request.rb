module Seatbelt
  module Models
   
    # Public: Abstraction of Travel-It travel request.
    class TravelRequest
      include Seatbelt::Ghost
      include Seatbelt::Document

      # Language of the request - Symbol, default :de
      attribute :language, Symbol, default: :de

      # Number of adults - Integer
      attribute :number_of_adults, Integer

      # Type of travel - Symbol (:package, :hotel_only, :flight_only)
      attribute :type_of_travel, Symbol

      # Departure date - Date
      attribute :departure_date, Date

      # Return date - Date
      attribute :return_date, Date

      # Minimum number of travel days - Integer
      attribute :min_days_of_travel, Integer

      # Maximum number of travel days - Integer
      attribute :max_days_of_travel, Integer

      # Offers grouping - Symbol (:none, :hotel, :hotel_per_operator)
      attribute :group_by, Symbol

      # Offers to skip in case there are more offers available - Integer
      attribute :skip, Integer

      # Number of offers to return - Integer
      attribute :limit, Integer

      # Sorting - Symbol
      #
      # When finding regions:
      #   ( :price, :name, :top, :top_family, :top_faraway )
      #
      # When finding offers
      #   ( :price, :operator, :hotel_name, :hotel_city, :hotel_category,
      #     :hotel_rating, :hotel_recommendation_rate )
      #
      # Append '_asc'  to sort ascending  (f.e. :price_asc)
      # Append '_desc' to sort descending (f.e. :price_desc)
      attribute :sort_by


      interface :instance do

        # Region names - Array<String> | Array<Regexp>
        define_property :region_names

        
        # Finds region by selfs attributes
        #
        # Returns Seatbelt::Models::RegionResponse or nil
        define :find_regions


        # Finds offers by selfs attributes
        #
        # Returns Seatbelt::Models::TravelResponse or nil
        define :find_offers


        property_accessible :number_of_adults, :type_of_travel,
                            :departure_date, :return_date, :language,
                            :min_days_of_travel, :max_days_of_travel,
                            :sort_by, :group_by, :skip, :limit, :region_names
      end

    end

  end
end