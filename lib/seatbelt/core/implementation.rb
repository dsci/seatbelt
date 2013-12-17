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

    end
  end
end
