module Seatbelt
  module Models

    # Public: Abstraction of Country page element.
    class Country
      include Seatbelt::Ghost
      include Seatbelt::Document

      # Two letter country code 
      attribute :lcode,             String
      # english country name
      attribute :name,              String
      # german country name
      attribute :name_de,           String
      # country coordinate polygones
      attribute :coordinates,       Array
      # country description long text
      attribute :text_long,         String
      # country description short text
      attribute :text_short,        String

    end
  end
end