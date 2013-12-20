module Seatbelt
  module Implementations

    class TravelRequest
      include Seatbelt::Gate

      # Seatbelt Instance methods
      implementation "Seatbelt::Models::TravelRequest", :instance do
        # Match Seatbelt attributes to TravelIt attributes
        match_property 'a' => 'number_of_adults'
        match_property 'b' => 'departure_date'
        match_property 'c' => 'return_date'
        match_property 'd' => 'min_days_of_travel'
        match_property 'e' => 'max_days_of_travel'
        match_property 'f' => 'skip'
        match_property 'g' => 'limit'
        match_property 'h' => 'type_of_travel'
        match_property 'i' => 'group_by'
        match_property 'j' => 'sort_by'
        match_property 'k' => 'region_names'

        # Other methods
        match 'find_offers' => 'find_offers'
      end      

      (:a..:k).each do |getter|
        setter = "#{getter}="

        define_method(getter) { props[getter] }
        define_method(setter) { |val| props[getter] = val }
      end

      def find_offers
      end

      def props
        @props ||= {}
      end

    end

  end
end