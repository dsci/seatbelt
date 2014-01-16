module Seatbelt
  module Models

    # Public: Abstraction of Travel-It region page element.
    class RegionOffer
      include Seatbelt::Document


      # region name
      attribute :region_name,               String
      # region 2letter code
      attribute :region_code,               String
      # lowest price
      attribute :lowest_price,              Float
      # lowest entire price
      attribute :lowest_entire_price,       Float
      # departure airport with lowest price
      attribute :airport_codes,             Array[String]

    end

  end
end