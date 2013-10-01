module Seatbelt
  module Synthesizeable
    extend self

    # Public: Combined getter and setter for a map of attributes that should
    # be used for synthesizing the proxy and the implementation object.
    #
    # map=nil - a Hash of proxy attributes as keys and implementation object
    #           attributes as values.
    #
    # If map is nil, it returns the synthesize map (or an Empty hash if not
    # previously set).
    def synthesize_map(map=nil)
      if map.nil?
        return @synthesize_map ||={}
      else
        @synthesize_map=map
      end
    end

    # Public: Defines a synthesizer for the implementation class. It takes an
    # Hash argument to define the class the object should by synthesized and
    # an additional adapter.
    #
    # options - A Hash containing synthesize configurations
    #           :from   - The class the implementation and proxy object has to
    #                     synthesized (String or Constant)
    #           :adapter- An optional class name that points to a implemented
    #                     Synthesizer. Defaults to
    #                     Seatbelt::Synthesizers::Document
    #
    def synthesize(options)
      klass_to_synthesize = options[:from]
      synthesize_adapter  = options.fetch(:adapter,
                                          "Seatbelt::Synthesizers::Document")
      synthesize_adapter  = Module.const_get(synthesize_adapter)
      unless klass_to_synthesize.respond_to?(:name)
        klass_to_synthesize = Module.const_get(klass_to_synthesize)
      end
      synthesize_obj = {:klass => klass_to_synthesize.name,
                        :adapter => synthesize_adapter}
      klass_to_synthesize.class.class_eval do
        def synthesizers
          @synthesizers ||= []
        end
      end
      klass_to_synthesize.synthesizers << synthesize_obj
    end
  end
end
