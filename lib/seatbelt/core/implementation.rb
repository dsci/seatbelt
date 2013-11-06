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
        namespace     = namespace
        @_scope       = Seatbelt::GateConfig.method_directives[scope]
        yield(self)
        iterator      = Core::Iterators::MethodConfig.
                                send("array_method_iterator",namespace,
                                     self,scope)
        bulk_methods.each(&iterator)
      end

      # Public: Builds an Hash representation that is used the method_added hook
      # (Seatbelt::Gate::Classmethods) to find the implementation methods of a
      # specific object level.
      #
      # hsh - An Hash containing the implementation method name as key and
      #       the API method as value.
      def match(hsh)
        implementation_method = hsh.keys.first.to_sym
        remote_method         = hsh.values.first
        bulk_methods << {
          implementation_method => {:as => "#{@_scope}#{remote_method}"}
        }
      end

    end
  end
end
