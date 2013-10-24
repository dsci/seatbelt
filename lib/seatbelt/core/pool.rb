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
      #                         :args             - An array of expected
      #                                             arguments as Symbols or
      #                                             Strings. If omitted the
      #                                             method expects no arguments.
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
        if lookup_tbl.map{|n| n.keys}.flatten.include?(args.first)
          raise Errors::MetaMethodDuplicateError
        end
        default_options   = { :scope          => :instance,
                              :block_required => false,
                              :arity          => 0
                            }
        options           = args.extract_options!
        if options.has_key?(:args)
          arity = options.delete(:args)
          size  = arity.size
          block_size = lambda do
            block_match = arity.join(",").scan(/\&{1,}/)
            size = size - block_match.size if block_match
            return size
          end
          if arity.join(",").match(/\*{1,}/)
            size = -block_size.call
            eqls = arity.join(",").scan(/[\=]+/).size
            size = size + eqls
            default_options[:arity] = size
          else
            size = block_size.call
            eqls = arity.join(",").scan(/[\=]+/).size
            size = eqls > 0 ? -size : size
            default_options[:arity] = size
          end
        end

        meta_definitions  = { args.first => default_options.merge(options) }

        lookup_tbl.set(meta_definitions)
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