module Seatbelt
  module Implementations

    class TravelRequest
      include Seatbelt::Gate

      # Seatbelt Instance methods
      implementation "Seatbelt::Models::TravelRequest", :instance do
        # Match Seatbelt attributes to TravelIt attributes
        match_property 'a' => 'region_names'

        # Other methods
        match 'find_regions' => 'find_regions'
        match 'find_offers'  => 'find_offers'
      end      

      (:a..:a).each do |getter|
        setter = "#{getter}="

        define_method(getter) { props[getter] }
        define_method(setter) { |val| props[getter] = val }
      end

      def find_regions
      end

      def find_offers
      end

      def props
        @props ||= {}
      end

    end

  end
end