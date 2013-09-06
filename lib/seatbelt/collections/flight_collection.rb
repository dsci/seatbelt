module Seatbelt
  module Collections
    # A collection to use 'has_many :flights, Seatbelt::Models::Flight'
    class FlightCollection < Seatbelt::Collections::Collection
    end
  end
end