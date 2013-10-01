module Seatbelt
  module Synthesizers

    # Public: A Synthesizer that syncs a Seatbelt::Document based implementation
    # class with a Seatbelt::Document proxy object
    class Document
      include Seatbelt::Synthesizer

      # The attributes to synthesize as Array.
      def synthesizable_attributes
        synthesizable_object.attributes.keys
      end

    end
  end
end