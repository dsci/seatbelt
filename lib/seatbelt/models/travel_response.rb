module Seatbelt
  module Models
   
    # Public: Instance to return for TravelRequest find_offers method
    class TravelResponse
      include Seatbelt::Document

      # Total number of offers available
      attribute :total, Integer

      # Position of first offer (starting with 1)
      attribute :from,  Integer

      # Position of last offer
      attribute :to,    Integer

      # Array of offers (subset of total offers available)
      attribute :docs,  Array[Seatbelt::Models::Offer]
    end
  
  end
end