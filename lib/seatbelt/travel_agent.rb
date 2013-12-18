module Seatbelt

  # Public: Interface to the implementation sections of TQL.
  # (Travel Query Language)
  #
  class TravelAgent

    # Public: Takes sentence an delegates it to the responding class.
    #
    # query - The natural language sentence as String.
    #
    # Example
    #   TravelAgent.tell_me "Hotel: Find the 2 cheapest near London"
    #   TravelAgent.tell_me "Offer: Find all for three weeks in Finnland"
    #
    # A query starts with the class name the query should pointed to following
    # by ':'. If this is omitted the class defaults to Offer
    def self.tell_me(query)
      model_prefix  = "Seatbelt::Models::"
      name_regex    = /^\s*\w*[:,]/
      result        = query.scan(name_regex).first
      klass         = result.gsub(":", "") if result.respond_to?(:gsub)
      klass         = "Offer" unless klass
      pattern       = query.gsub(name_regex, "").lstrip
      Module.const_get("#{model_prefix}#{klass}").send(:respond,pattern)
    end

  end
end
