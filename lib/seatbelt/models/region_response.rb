module Seatbelt
  module Models
   
    # Public: Instance to return for TravelRequest find_offers method
    class RegionResponse
      include Seatbelt::Document

      # Array of regions
      attribute :docs,  Array[Seatbelt::Models::RegionOffer]
    end
  
  end
end