module Seatbelt
  module Gate
    module Implementation

      # Internal: Helper array to store method iterationable values.
      def bulk_methods
        @bulk_methods ||= []
      end
      private :bulk_methods
      # Public: Provides definition for which class and object level (instance,
      # class) the implementation methods match the API class methods.
      #
      # namespace - The API class (with complete namespace)
      # scope     - The object level of 'namespace' [:instance, :class]
      # &block    - The block that contains the implementation match
      #             definitions.
      #
      # Example:
      #
      #   class ImplementHotel
      #     include Seatbelt::Gate
      #
      #     implementation "Hotel", :class do
      #       match 'implement_find_region' => 'find_nearby'
      #     end
      #
      #     def implement_find_region(options)
      #       #....
      #     end
      #   end
      #
      def implementation(namespace, scope, &block)
        methods       = []
        @_namespace     = namespace
        @_scope       = Seatbelt::GateConfig.method_directives[scope]
        yield(self)
        iterator      = Core::Iterators::MethodConfig.
                                send("array_method_iterator",@_namespace,
                                     self,scope)
        bulk_methods.each(&iterator)
      end

      # Public: Builds an Hash representation that is used by the method_added
      # hook (Seatbelt::Gate::Classmethods) to find the implementation methods
      # of a specific object level.
      #
      # If the argument includes a :superclass key with a truthy value,
      # #implementation_from_superclass is called to simulate similiar behaviour
      # to the method added hook.
      #
      # Examples:
      #
      #   implementation "Book", :instance do
      #     match 'implementation_publishing' => 'publishing'
      #     match 'implementation_paper_type' => 'paper_type',
      #            :superclass => true
      #   end
      #
      # hsh - An Hash containing the implementation method name as key and
      #       the API method as value.
      #       :superclass - defines that there will be an extra lookup for an
      #                     implementation method in the class' superclass.
      #                     (defaults to false)
      def match(hsh)
        hsh.stringify_keys!
        superclass_definition = hsh.fetch("superclass", false)
        hsh.delete("superclass")
        implementation_method = hsh.keys.first.to_sym
        remote_method         = hsh.values.first
        if superclass_definition
          config = {:as => "#{@_namespace}#{@_scope}#{remote_method}"}
          self.send(:implementation_from_superclass,
                    implementation_method, config)
        end
        bulk_methods << {
          implementation_method => {:as => "#{@_scope}#{remote_method}"}
        }
      end

      # Public: Builds an Hash representation for property that is passed to
      # #match(hsh)
      #
      # A property is an ivar that is accessible through a getter and setter.
      #
      # #match_property is only useable within the :instance scope,
      #
      # Examples:
      #
      #   # Having an identical property wthin the interface.
      #   implementation "Book", :instance do
      #     match_property 'author'
      #   end
      #
      #   # Property names differ
      #   implementation "Book", :instance do
      #     match_property 'implementation_title' => 'title'
      #   end
      #
      #   # Property is defined in the superclass
      #   implementation "Novel", :instance do
      #     match_property :publisher, :superclass => true
      #   end
      #
      # args - An argumentlist containing one of the following
      #         - property name as String or Symbol
      #         - config Hash similiar to #match
      #         - an Hash containing :superclass key (optional)
      #
      def match_property(*args)
        options   = {}
        if args.size.eql?(1)
          property  = args.pop
        else
          options   = args.pop
          property  = args.shift
          options.stringify_keys!
        end
        if property.is_a?(String) || property.is_a?(Symbol)
          [property, "#{property}="].each do |method|
            match_options               = {}
            match_options[method]       = method
            match_options["superclass"] = options.fetch("superclass", false)
            match(match_options)
          end
        elsif property.is_a?(Hash)
          property.stringify_keys!
          implement_property  = property.keys.first.to_sym
          remote_property     = property.values.first
          [{implement_property => remote_property},
           {"#{implement_property}=" => "#{remote_property}="}].each do |opt|
            if property.has_key?("superclass")
              opt["superclass"] = property.fetch("superclass")
            end
            match(opt)
          end
        else
          raise Seatbelt::Errors::TypeMissmatchError.
                                  new("String, Symbol or Hash",
                                      property.class.name)
        end
      end

    end
  end
end
