module Seatbelt

  # Public: Interface to the implementation sections of TQL.
  # (TranslationQuery Language)
  #
  class Translator

    class Config

      def self.namespace
        @namespace ||= ""
      end

      def self.namespace=(namespace)
        @namespace =  namespace
      end

      def self.name_regex
        @name_regex ||= /^\s*\w*[:,]/
      end

      def self.name_regex=(regexp)
        @name_regex = regexp
      end

      def self.default_model_class
        @default_model_class
      end

      def self.default_model_class=(klass)
        @default_model_class = klass
      end

    end


    def self.setup(&block)
      yield(config)
    end

    def self.config
      Translator::Config
    end

    # Public: Takes sentence an delegates it to the responding class.
    #
    # query - The natural language sentence as String.
    #
    # Example
    #   Translator.tell_me "Hotel: Find the 2 cheapest near London"
    #   Translator.tell_me "Offer: Find all for three weeks in Finnland"
    #
    # A query starts with the class name the query should pointed to following
    # by ':'. If this is omitted the class defaults to Offer
    def self.tell_me(query)
      model_prefix  = config.namespace
      name_regex    = config.name_regex
      result        = query.scan(name_regex).first
      klass         = result.gsub(":", "") if result.respond_to?(:gsub)
      klass         = config.default_model_class unless klass
      pattern       = query.gsub(name_regex, "").lstrip
      Module.const_get("#{model_prefix}#{klass}").send(:respond,pattern)
    end

  end
end
