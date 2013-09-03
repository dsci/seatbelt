module Seatbelt
  module Models

    # Public: Abstraction of Picture page element.
    class Picture
      include Seatbelt::Ghost
      include Seatbelt::Document

      # Hotel ID
      attribute :hotel_id,        Integer
      # 
      attribute :caption,         String
      # URL to Thumbnail Picture
      attribute :thumbnail_url,   String
      # URL to Picture
      attribute :url,             String
      # Picture width
      attribute :width,           Integer      
      # Picture height
      attribute :height,          Integer
      # Is Main Picture?
      attribute :default_image,   Boolean
      # Picture Sourche (actual: Expedia/Panoramio)
      attribute :source,          String      
    end
  end
end