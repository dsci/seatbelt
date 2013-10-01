module Seatbelt
  module Synthesizers

    # Public: A Synthesizer that syncs a Mongoid::Document based implementation
    # class with a Seatbelt::Document proxy object
    class Mongoid
      include Seatbelt::Synthesizer

      # The attributes to synthesize as Array.
      def synthesizable_attributes
        synthesizable_object.fields.keys.map(&:to_sym)
      end

    end
  end
end