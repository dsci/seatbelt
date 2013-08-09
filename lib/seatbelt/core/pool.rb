module Seatbelt
  module Pool

    # Public: Provides storage of meta-method definitions.
    # All classes that declare (API) meta-methods have to include this module
    # by using the Seatbelt::Terminal wrapper.
    #
    # For API design matters: https://gist.github.com/dsci/a96048884fdff81aca68
    module Api
      extend self

      # Public: Registeres a meta-method at the method pool by adding the
      # method configuration to a lookup table.
      #
      # Each class that includes Seatbelt::Terminal has its own lookup table.
      #
      # *args - An argument list consisting of
      #         * method_name - that has to be the first argument (required)
      #         * options     - an options Hash that refines the methods usage:
      #                         :scope           - the method type
      #                                            [:instance, :class]
      #                                            defaults to :instance
      #                         :block_required  - defines if the method
      #                                            require a Ruby Block for
      #                                            usage.
      #
      #
      # If no arguments are passed, a Seatbelt::Errors::ArgumentsMissmatchError
      # is raised.
      # Raises a Seatbelt::Errors::MissingMetaMethodName, if no meta-method
      # name was given.
      # If a meta-method name is passed that already exists in the lookup table,
      # a Seatbelt::Errors::MetaMethodDuplicateError is raised.
      def api_method(*args)
        raise Errors::ArgumentsMissmatchError if args.empty?
        raise Errors::MissingMetaMethodName if args.first.is_a?(Hash)
        if @lookup_tbl.map{|n| n.keys}.flatten.include?(args.first)
          raise Errors::MetaMethodDuplicateError
        end
        default_options   = { :scope          => :instance,
                              :block_required => false
                            }
        options           = args.last.is_a?(::Hash) ? args.pop : {}
        meta_definitions  = { args.first => default_options.merge(options) }

        lookup_tbl << meta_definitions
      end


      # Public: An accessor to the lookup table array.
      #
      # Creates the table if it doesn't exists.
      #
      # Returns an instance of Lookup Table
      def lookup_tbl
        @lookup_tbl = LookupTable.new if @lookup_tbl.nil?
        return @lookup_tbl
      end

    end
  end
end